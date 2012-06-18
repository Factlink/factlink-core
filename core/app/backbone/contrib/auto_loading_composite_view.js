window.AutoloadingCompositeView = Backbone.Marionette.CompositeView.extend({
  constructor: function(options){
    Backbone.Marionette.CompositeView.prototype.constructor.apply(this, arguments);
    this.collection.loadMore();
  },


  loadMore: function() {
    if ( this.bottomOfViewReached()) {
      this.collection.loadMore();
    }
  },

  bottomOfViewReached: function() {
    var bottomOfTheViewport = window.pageYOffset + window.innerHeight;
    var bottomOfEl = this.$el.offset().top + this.$el.outerHeight();

    if ( bottomOfEl < bottomOfTheViewport ) {
      return true;
    } else if ($(document).height() - ($(window).scrollTop() + $(window).height()) < 700) {
      return true;
    } else {
      return false;
    }
  },

  bindScroll: function() {
    this.unbindScroll();
    $(window).on('scroll.' + this.cid, _.bind(function MCBiggah() {
      this.loadMore();
    }, this));
  },

  unbindScroll: function() {
    $(window).off('scroll.' + this.cid);
  },

  close: function() {
    Backbone.Marionette.CompositeView.prototype.close.apply(this, arguments);
    this.unbindScroll();
  },


  onRender: function() {
    this.bindScroll();

    if (this.collection.length === 0 && !this.collection._loading) {
      this.showEmpty();
    }
  },


  beforeReset: function(e){
    this.collection.stopLoading();
  },

  afterAdd: function () {
    this.hideEmpty();
  },

  showEmpty: function(){},
  hideEmpty: function(){}

});
