window.AutoCompletedAddToChannelView = Backbone.View.extend({
  tagName: "div",
  className: "add_to_channel",

  events: {
    "keydown input.typeahead": "parseKeyInput"
  },

  tmpl: HoganTemplates["channels/_auto_completed_add_to_channel"],

  render: function () {
    this.$el.html( this.tmpl.render() );

    return this;
  },

  parseKeyInput: function (e) {
    console.info( "parseKeyInput", e.keyCode );

    switch(e.keyCode) {
      case 13:
        this.parseReturn();
        break;
      case 40:
        this.moveSelectionDown();
        break;
      case 38:
        this.moveSelectionUp();
        break;
      default:
        this.autoComplete();
        break;
    }
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
        || searchValue.length < 1 ) {
      return;
    }

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
