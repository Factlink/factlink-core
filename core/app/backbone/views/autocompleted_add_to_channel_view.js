var updateWindowHeight = function(){
  if (window.updateHeight) {
    window.updateHeight();
  }
};


window.AutoCompletesView = Backbone.View.extend({
  initialize: function(){
    this.list = [];
  },

  closeList: function() {
    _.each( this.list, function (view) {
      view.close();
    });

    this.list = [];
  },

  onClose: function(){
    this.closeList();
  },

  activeChannelKey: function(){
    return this.options.mainView._activeChannelKey;
  },

  setActiveChannelKey: function(value){
    this.options.mainView._activeChannelKey = value;
  },

  deActivateCurrent: function(){
    if ( this.list[this.activeChannelKey()] ) {
      this.list[this.activeChannelKey()].trigger('deactivate');
    }

  }

});

window.AutoCompletedAddToChannelView = Backbone.Factlink.PlainView.extend({
  tagName: "div",
  className: "add-to-channel",

  events: {
    "keydown input.typeahead"       : "parseKeyDown",
    "keyup input.typeahead"         : "autoComplete",
    "focus input.typeahead"         : "onFocusInput",
    "click div.fake-input"          : "focusInput",
    "click div.auto_complete"       : "parseReturn",
    "click div.fake-input a"        : "parseReturn",
    "blur input.typeahead"          : "blurInput",
    "click .show-input-button"      : "showInput",
    "mouseenter .auto_complete>div" : "selectAddNew",
    "mouseleave .auto_complete>div" : "deActivateAddNew"
  },

  activeChannelKey: function(){
    return this._activeChannelKey;
  },

  setActiveChannelKey: function(value){
    this._activeChannelKey = value;
  },

  template: "channels/_auto_completed_add_to_channel",

  initialize: function () {
    this.vent = new Backbone.Marionette.EventAggregator();

    this.collection = new OwnChannelCollection();
    this._added_channels_view = new AutoCompletedAddedChannelsView({
      collection: this.collection,
      mainView: this
    });

    this._auto_completes_view = new AutoCompletesView({
      mainView: this
    });

    var self = this;
    this.collection.on('remove', function(ch){
      self.onRemoveChannel(ch);
    });
    this.collection.on('add', function(ch){
      self.onAddChannel(ch);
    });
  },

  onRemoveChannel: function(ch) {
    if (this.collection.length) {
      this.$el.addClass('hide-input');
    } else {
      this.$el.removeClass('hide-input');
    }
  },

  onAddChannel: function(ch) {
    this.$el.addClass('hide-input');
    updateWindowHeight();
  },

  onRender: function () {
    this.$el.find('.auto_complete ul').preventScrollPropagation();

    this._added_channels_view.render();
    this.$el.find('div.added_channels_container').html(this._added_channels_view.el);

    updateWindowHeight();
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
      .find('.fake-input input').focus();
  },

  focusInput: function() {this.$('input.typeahead').focus(); },
  onFocusInput: function () { this.$el.addClass('focus'); },
  blurInput: function () { this.$el.removeClass('focus'); },

  moveSelectionUp: function (e) {
    var prevKey;

    if ( this.activeChannelKey() !== undefined ) {
      prevKey = this.activeChannelKey() - 1;
    } else {
      prevKey = -1;
    }

    this.setActiveAutoComplete(prevKey, false);

    e.preventDefault();
  },

  moveSelectionDown: function (e) {
    var nextKey;

    if ( this.activeChannelKey() !== undefined ) {
      nextKey = this.activeChannelKey() + 1;
    } else {
      nextKey = 0;
    }

    this.setActiveAutoComplete(nextKey, false);


    e.preventDefault();
  },

  deActivateCurrent: function(){
    this._auto_completes_view.deActivateCurrent();
    this.deActivateAddNew();
  },

  fixKeyModulo: function(key){
    var maxval;
    if (this.isAddNewVisible()){
      maxval = this._auto_completes_view.list.length;
    } else {
      maxval = this._auto_completes_view.list.length - 1;
    }
    if (key > maxval) {key = 0;}
    if (key < 0) {key = maxval;}
    return key;
  },


  setActiveAutoComplete: function (key, scroll) {
    this.deActivateCurrent();
    key = this.fixKeyModulo(key);

    if (key < this._auto_completes_view.list.length && key >= 0) {
      this._auto_completes_view.list[key].trigger('activate');
      if ( typeof scroll === "boolean") {
        var list = this.$el.find("div.auto_complete ul")[0];
        if (list.scrollHeight > list.clientHeight) {
          this._auto_completes_view.list[key].el.scrollIntoView(scroll);
        }
      }
    } else {
      this.activateAddNew();
    }
    this.setActiveChannelKey(key);
  },

  selectAddNew: function () {
    if ( ! this.isAddNewVisible() ) {
      return false;
    }

    if ( typeof this.activeChannelKey() === "number" ) {
      this.deActivateAutoCompleteView();
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
    this.setActiveAutoComplete(this._auto_completes_view.list.indexOf(view));
  },

  deActivateAutoCompleteView: function () {
    var activeview = this._auto_completes_view.list[this.activeChannelKey()];
    if (activeview !== undefined) {
      activeview.trigger('deactivate');
    }
    this.setActiveChannelKey(undefined);
  },

  parseReturn: function (e) {
    e.preventDefault();
    e.stopPropagation();

    this.disable();

    if ( this.activeChannelKey() >= 0 && this.activeChannelKey() < this._auto_completes_view.list.length ) {
      var selected = this._auto_completes_view.list[this.activeChannelKey()].model;

      this.$el.find('input.typeahead').val( selected.get('title') );

      if ( selected.get('user_channel') ) {
        this.addNewChannel( selected.get('user_channel') );

        return;
      }
    }

    this.createNewChannel(e);
  },

  isDupe: function(title){
    return this.collection.where({title: title}).length > 0;
  },

  completelyDisappear: function (){
    this.hideAutoComplete();
    this.enable();
    this.hideLoading();
    this.clearInput();
  },

  createNewChannel: function (e) {
    var title = this.$el.find('input.typeahead').val();
    title = $.trim(title);
    var dupe = false;

    this.showLoading();
    if ( (title.length < 1) || (this.isDupe(title)) ) {
      this.completelyDisappear();
      return;
    }

    var to_create_user_channels = this._autoCompletes.filter( function(item) {
      return item.get('title') == title && item.get('user_channel');
    });

    if (to_create_user_channels.length > 0) {
      this.addNewChannel(to_create_user_channels[0].get('user_channel'));
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
    this.vent.trigger("addChannel", channel);
    this.collection.add(channel);
    this.completelyDisappear();
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

  autoComplete: _.debounce(function () {
    var searchValue = this.$el.find('input.typeahead').val();

    this.updateText();

    if ( this._lastKnownSearchValue === searchValue || ! this._proceed ) {
      return;
    }

    this._lastKnownSearchValue = searchValue;
    this.setActiveChannelKey(undefined);

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
    this.setActiveAutoComplete(0, false);

    updateWindowHeight();
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
    this.$('.auto_complete').hide();
  },

  showAutoComplete: function () {
    this.$('.auto_complete').show();
  },


  clearAutoComplete: function () {
    this._auto_completes_view.closeList();

    this._autoCompletes = new Backbone.Collection();

    this.$el.find('.auto_complete').addClass('empty');

    this.hideAutoComplete();

    this.deActivateAddNew();

    this.showAddNew();
  },

  onClose: function(){
    this._auto_completes_view.close();
  },

  alreadyAdded: function(channel) {
    return channel.get('user_channel') && this.collection.get( channel.get('user_channel').id );
  },

  addAutoComplete: function (channel) {
    var self = this;
    if ( ! this.alreadyAdded(channel) ) {
      this._autoCompletes.add(channel);

      var view = new AutoCompletedChannelView({
        model: channel,
        query: this._lastKnownSearchValue,
        parent: this
      });
      view.render();

      this.$('.auto_complete>ul').append(view.el);

      this.$('.auto_complete').removeClass('empty');

      this._auto_completes_view.list.push(view);

      this.showAutoComplete();

      if ( channel.get('user_channel') ) {
        var lowerCaseTitle = channel.get('user_channel').title.toLowerCase();
        var lowerCaseSearch = this._lastKnownSearchValue.toLowerCase();

        if ( lowerCaseSearch === lowerCaseTitle ) {
          this.hideAddNew();
        }
      }
    }
  }

});