var updateWindowHeight = function(){
  if (window.updateHeight) {
    window.updateHeight();
  }
};

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

    this._autoCompletes = new TopicSearchResults();

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

    this._autoCompletes.on('add', function(ch){
      self.addAutoComplete(ch);
    });
    this._autoCompletes.on('reset', function(){
      self._autoCompletes.forEach(function(ch){
        self.addAutoComplete(ch);
      });
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
        this._auto_completes_view.moveSelectionDown(e);
        break;
      case 38:
        this._auto_completes_view.moveSelectionUp(e);
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

  deActivateCurrent: function(){
    this._auto_completes_view.deActivateCurrent();
    this.deActivateAddNew();
  },

  setActiveAutoComplete: function (key, scroll) {
    this._auto_completes_view.setActiveAutoComplete(key,scroll);
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
    this.$('.auto_complete>div').addClass('active');
  },

  deActivateAddNew: function () {
    this.$('.auto_complete>div').removeClass('active');
  },

  isAddNewActive: function () {
    return this.$('.auto_complete>div').hasClass('active');
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

      this.$('input.typeahead').val( selected.get('title') );

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
    var title = this.$('input.typeahead').val();
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
    this.$('input.typeahead').val('');

    if ( this.collection.length ) {
      this.$el.addClass('hide-input');
    }
  },

  disable: function () {
    this.$el
      .addClass('disabled')
      .find('input.typeahead').prop('disabled', true);

    this.$('.btn').addClass('disabled');
  },

  enable: function () {
    this.$el
      .removeClass('disabled')
      .find('input.typeahead').prop('disabled', false);

    this.$('.btn').removeClass('disabled');
  },

  showLoading: function () {
    this.$('.loading').show();
  },

  hideLoading: function () {
    this.$('.loading').hide();
  },

  updateText: function () {
    var value = this.$el.find('input.typeahead').val();
    if ( value.length ) {
      this.$el.addClass('has-text');

      this.$(".search").text( value );
    } else {
      this.$el.removeClass('has-text');
    }
  },

  autoComplete: _.debounce(function () {
    var searchValue = this.$('input.typeahead').val();

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

    this.clearAutoComplete();

    this._autoCompletes.setSearch(searchValue);

    var self = this;
    this._autoCompletes.fetch({success:function(){
      self.showAutoComplete();
      self.setActiveAutoComplete(0, false);
      updateWindowHeight();
    }});

  }, 300),

  addAutoComplete: function(channel){
    this._auto_completes_view.addAutoComplete(channel);
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

    this._autoCompletes.reset([]);

    this.$('.auto_complete').addClass('empty');

    this.hideAutoComplete();

    this.deActivateAddNew();

    this.showAddNew();
  },

  onClose: function(){
    this._auto_completes_view.close();
  }

});