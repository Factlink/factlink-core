window.AutoCompletedAddToChannelView = Backbone.View.extend({
  tagName: "div",
  className: "add_to_channel",

  events: {
    "keydown input.typeahead": "parseKeyDown",
    "keyup input.typeahead": "autoComplete",
    "focus input.typeahead": "focusInput",
    "click div.auto_complete": "parseReturn",
    "click div.fake_input a": "parseReturn",
    "blur input.typeahead": "blurInput",
    "click .show-input-button": "showInput",
    "mouseenter .auto_complete>div": "selectAddNew",
    "mouseleave .auto_complete>div": "deActivateAddNew"
  },

  tmpl: HoganTemplates["channels/_auto_completed_add_to_channel"],

  initialize: function () {
    this.collection = new OwnChannelCollection();
    this.collection.bind('add', this.addChannel, this);

    this._channelViews = {};
  },

  render: function () {
    this.$el.html( this.tmpl.render() );

    this.reset();

    return this;
  },

  parseKeyDown: function (e) {
    this._proceed = false;

    switch(e.keyCode) {
      case 13:
        this.parseReturn(e);
        break;
      case 40:
        this.moveSelectionDown(e);
        break;
      case 38:
        this.moveSelectionUp(e);
        break;
      case 27:
        this.hideAutoComplete();
        break;
      default:
        this._proceed = true;
        break;
    }
  },

  showInput: function () {
    this.$el
      .removeClass('hide-input')
      .find('.fake_input input').focus();
  },

  addChannel: function (channel) {
    var view = new AutoCompletedAddedChannelView({
      model: channel,
      rootView: this
    }).render();

    this.$el.addClass('hide-input');

    this.$el.find('.added_channels').append( view.el );

    this._channelViews[channel.id] = view;

    if ( window.updateHeight ) {
      window.updateHeight();
    }
  },

  reset: function () {
    _.each(this._channelViews, function (view) {
      view.remove();
    });

    this._channelViews = {};

    this.collection.each(function(channel) {
      this.addChannel(channel);
    }, this);
  },

  focusInput: function () { this.$el.addClass('focus'); },
  blurInput: function () { this.$el.removeClass('focus'); },

  moveSelectionUp: function (e) {
    var prevKey;

    if ( this._activeChannelKey !== undefined ) {
      // There is an active channel key
      if ( this._autoCompleteViews[this._activeChannelKey - 1] ) {
        // Select the previous key
        prevKey = this._activeChannelKey - 1;
      }
    }

    if ( typeof prevKey === "undefined" ) {
      // No previous item to be selected
      if ( ! this.isAddNewActive() ) {
        // Select addNew
        this.selectAddNew();

        if ( ! this.isAddNewActive() ) {
          prevKey = this._autoCompleteViews.length - 1;
        }
      } else {
        prevKey = this._autoCompleteViews.length - 1;
      }
    }

    if ( typeof prevKey === "number" ) {
      this.setActiveAutoComplete(prevKey, true);
    }

    e.preventDefault();
  },

  moveSelectionDown: function (e) {
    var nextKey;

    if ( this._activeChannelKey !== undefined ) {
      if ( this._autoCompleteViews[this._activeChannelKey + 1] ) {
        nextKey = this._activeChannelKey + 1;
      }
    } else {
      nextKey = 0;
    }

    if ( typeof nextKey === "undefined" ) {
      this.selectAddNew();

      if ( ! this.isAddNewActive() ) {
        nextKey = 0;
      }
    }

    if ( typeof nextKey === "number" ) {
      this.setActiveAutoComplete(nextKey, false);
    }


    e.preventDefault();
  },

  setActiveAutoComplete: function (key, scroll) {
    if ( this._autoCompleteViews[this._activeChannelKey] ) {
      this._autoCompleteViews[this._activeChannelKey].deActivate();
    }

    this.deActivateAddNew();

    this._autoCompleteViews[key].activate();

    if ( typeof scroll === "boolean" ) {
      this._autoCompleteViews[key].el.scrollIntoView(scroll);
    }

    this._activeChannelKey = key;
  },

  selectAddNew: function () {
    if ( ! this.isAddNewVisible() ) {
      return false;
    }

    if ( typeof this._activeChannelKey === "number" ) {
      this._autoCompleteViews[this._activeChannelKey].deActivate();

      this._activeChannelKey = undefined;
    }

    this.activateAddNew();
  },

  activateAddNew: function () {
    this.$el.find('.auto_complete>div').addClass('active');
  },

  deActivateAddNew: function () {
    this.$el.find('.auto_complete>div').removeClass('active');
  },

  isAddNewActive: function () {
    return this.$el.find('.auto_complete>div').hasClass('active');
  },

  activateAutoCompleteView: function (view) {
    _.each(this._autoCompleteViews, function (autocomplete, key) {
      if ( view === autocomplete ) {
        this.setActiveAutoComplete(key);
      }
    }, this);
  },

  deActivateAutoCompleteView: function (view) {
    this._autoCompleteViews[ this._activeChannelKey ].deActivate();

    this._activeChannelKey = undefined;
  },

  parseReturn: function (e) {
    e.preventDefault();
    e.stopPropagation();

    this.disable();

    if ( this._activeChannelKey !== undefined ) {
      var selected = this._autoCompleteViews[ this._activeChannelKey].model;

      this.$el.find('input.typeahead').val( selected.get('title') );

      if ( selected.get('user_channel') ) {
        this.addNewChannel( selected.get('user_channel') );

        return;
      }
    }

    this.createNewChannel(e);
  },

  createNewChannel: function (e) {
    var title = this.$el.find('input.typeahead').val();
    var dupe = false;
    var isUserChannel = false;

    this.showLoading();

    if ( $.trim(title).length < 1 ) {
      this.hideAutoComplete();

      this.enable();
      this.hideLoading();

      return;
    }

    this.collection.each(function (channel) {
      if ( channel.get('title') === title ) {
        dupe = true;
      }
    });

    if ( dupe ) {
      this.hideAutoComplete();

      this.enable();
      this.hideLoading();
      this.clearInput();

      return;
    }


    _.each(this._autoCompletes, function (autoComplete) {
      if ( autoComplete.get('title') === title && autoComplete.get('user_channel') ) {
        isUserChannel = true;

        this.addNewChannel(autoComplete);

        return false;
      }
    }, this);

    if ( isUserChannel ) {
      return;
    }

    $.ajax({
      url: '/' + currentUser.get('username') + '/channels',
      data: {
        title: title
      },
      type: "POST"
    }).done( _.bind( this.addNewChannel, this ) );

    e.preventDefault();
  },

  addNewChannel: function (channel) {
    channel = new Channel(channel);

    currentUser.channels.add(channel);
    this.collection.add(channel);

    this.hideAutoComplete();

    this.enable();
    this.hideLoading();
    this.clearInput();
  },

  clearInput: function () {
    this.$el.find('input.typeahead').val('');

    if ( this.collection.length ) {
      this.$el.addClass('hide-input');
    }
  },

  disable: function () {
    this.$el
      .addClass('disabled')
      .find('input.typeahead').prop('disabled', true);

    this.$el.find('.btn').addClass('disabled');
  },

  enable: function () {
    this.$el
      .removeClass('disabled')
      .find('input.typeahead').prop('disabled', false);

    this.$el.find('.btn').removeClass('disabled');
  },

  showLoading: function () {
    this.$el.find('.loading').show();
  },

  hideLoading: function () {
    this.$el.find('.loading').hide();
  },

  updateText: function () {
    var value = this.$el.find('input.typeahead').val();
    if ( value.length ) {
      this.$el.addClass('has-text');

      this.$el.find(".search").text( value );
    } else {
      this.$el.removeClass('has-text');
    }
  },

  autoComplete: _.throttle(function () {
    var searchValue = this.$el.find('input.typeahead').val();

    this.updateText();

    if ( this._lastKnownSearchValue === searchValue
        || ! this._proceed ) {
      return;
    }

    this._lastKnownSearchValue = searchValue;
    this._activeChannelKey = undefined;

    if (searchValue.length < 1) {
      this.hideAutoComplete();
      return;
    }

    this.showLoading();

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

      this.hideLoading();
    }, this ) );
  }, 300),

  updateAutoComplete: function (channels) {
    this.clearAutoComplete();

    _.each(channels, this.addAutoComplete, this);

    this.showAutoComplete();

    if ( window.updateHeight ) {
      window.updateHeight();
    }
  },

  hideAddNew: function () {
    this.$el.addClass('hide-add-new');
  },

  showAddNew: function () {
    this.$el.removeClass('hide-add-new');
  },

  isAddNewVisible: function () {
    return ! this.$el.hasClass('hide-add-new');
  },

  hideAutoComplete: function () {
    this.$el.find('.auto_complete').hide();
  },

  showAutoComplete: function () {
    this.$el.find('.auto_complete').show();
  },

  clearAutoComplete: function () {
    _.each( this._autoCompleteViews, function (view) {
      view.close();
    });

    this._autoCompleteViews = [];
    this._autoCompletes = [];

    this.$el.find('.auto_complete').addClass('empty');

    this.hideAutoComplete();

    this.deActivateAddNew();

    this.showAddNew();
  },

  addAutoComplete: function (channel) {
    if ( ! ( channel.get('user_channel')
                && this.collection.get( channel.get('user_channel').id ) ) ) {
      this._autoCompletes.push(channel);

      var view = new AutoCompletedChannelView({
        model: channel,
        query: this._lastKnownSearchValue,
        parent: this
      });
      view.render();

      this.$el.find('.auto_complete>ul').append(view.el);

      this.$el.find('.auto_complete').removeClass('empty');

      this._autoCompleteViews.push(view);

      this.showAutoComplete();

      if ( channel.get('user_channel') ) {
        var lowerCaseTitle = channel.get('user_channel').title.toLowerCase();
        var lowerCaseSearch = this._lastKnownSearchValue.toLowerCase();

        if ( lowerCaseSearch === lowerCaseTitle ) {
          this.hideAddNew();
        }
      }
    }
  },

  removeAddedChannel: function (id) {
    this._channelViews[id].remove();

    delete this._channelViews[id];

    this.collection.remove(id);

    if ( this.collection.length ) {
      this.$el.addClass("hide-input");
    } else {
      this.$el.removeClass("hide-input");
    }
  }
});
