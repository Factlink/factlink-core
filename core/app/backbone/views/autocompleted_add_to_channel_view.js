window.AutoCompletedAddToChannelView = Backbone.View.extend({
  tagName: "div",
  className: "add_to_channel",

  events: {
    "keydown input.typeahead": "parseKeyDown",
    "keyup input.typeahead": "autoComplete"
  },

  tmpl: HoganTemplates["channels/_auto_completed_add_to_channel"],

  render: function () {
    this.$el.html( this.tmpl.render() );

    return this;
  },

  parseKeyDown: function (e) {
    console.info( "parseKeyDown", e.keyCode );

    this._proceed = false;

    switch(e.keyCode) {
      case 13:
        this.parseReturn();
        break;
      case 40:
        this.moveSelectionDown(e);
        break;
      case 38:
        this.moveSelectionUp(e);
        break;
      default:
        this._proceed = true;
        break;
    }
  },

  moveSelectionUp: function (e) {
    var prevKey = this._autoCompleteViews.length - 1;

    if ( this._activeChannelKey !== undefined ) {
      if ( this._autoCompleteViews[this._activeChannelKey - 1] ) {
        prevKey = this._activeChannelKey - 1;
      }
    }

    this.setActiveAutoComplete(prevKey);

    e.preventDefault();
  },

  moveSelectionDown: function (e) {
    var nextKey = 0;

    if ( this._activeChannelKey !== undefined ) {
      if ( this._autoCompleteViews[this._activeChannelKey + 1] ) {
        nextKey = this._activeChannelKey + 1;
      }
    }

    this.setActiveAutoComplete(nextKey);

    e.preventDefault();
  },

  parseReturn: function () {
    if ( this.hasSelection() ) {
      this.$el.find('input.typeahead').val( this.selected.get('title') );
    }

    this.addNewChannel();
  },

  autoComplete: _.throttle(function () {
    var searchValue = this.$el.find('input.typeahead').val();

    if ( this._lastKnownSearchValue === searchValue
        || searchValue.length < 1
        || !this._proceed ) {
      return;
    }

    console.info( "autoComplete", searchValue );

    this._lastKnownSearchValue = searchValue;

    $.ajax({
      type: "GET",
      url: "/" + currentUser.get('username') + "/channels/find",
      data: {
        s: searchValue
      }
    }).done( _.bind( function (data) {
      var channels = _.map(data, function (channel) {
        return new AutoCompletedChannel(channel);
      });

      this.updateAutoComplete(channels);
    }, this ) );
  }, 300),

  updateAutoComplete: function (channels) {
    this.clearAutoComplete();

    _.each(channels, this.addAutoComplete, this);
  },

  clearAutoComplete: function () {
    _.each( this._autoCompleteViews, function (view) {
      view.remove();
    });

    this._autoCompleteViews = [];
    this._autoCompletes = [];
  },

  addAutoComplete: function (channel) {
    this._autoCompletes.push(channel);

    var view = new AutoCompletedChannelView({
      model: channel,
      query: this._lastKnownSearchValue
    }).render();

    this.$el.find('.auto_complete>ul').append(view.el);

    this._autoCompleteViews.push(view);
  }
});
