function extendWithAutoloading(superclass) {
  return superclass.extend({
    constructor: function(options){
      superclass.prototype.constructor.apply(this, arguments);
      this.collection.loadMore();
      this.on('add', _.bind(function(){
        this.hideEmpty();
      },this));
      this.collection.on('stopLoading', this.afterLoad, this);

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

    afterLoad: function() {

      if (this.collection.length === 0 && !this.collection._loading) {
        this.showEmpty();
      }

      if ( this.bottomOfViewReached()) {
        this.collection.loadMore();
      }
    },

    bindScroll: function() {
      this.unbindScroll();
      $(window).on('scroll.' + this.cid, _.bind(function MCBiggah() {
        this.afterLoad();
      }, this));
    },

    unbindScroll: function() {
      $(window).off('scroll.' + this.cid);
    },

    close: function() {
      superclass.prototype.close.apply(this, arguments);
      this.unbindScroll();
    },

    render: function() {
      superclass.prototype.render.apply(this, arguments);
      this.bindScroll();
    },


    reset: function(e){
      this.collection.stopLoading();
      superclass.prototype.reset.apply(this, arguments);
    },

    showEmpty: function(){},
    hideEmpty: function(){}

  });
}
window.AutoloadingCompositeView = extendWithAutoloading(Backbone.Marionette.CompositeView);
