//= require ./composite_view

function extendWithAutoloading(superclass) {
  return superclass.extend({
    constructor: function(options){
      superclass.prototype.constructor.apply(this, arguments);
      this.collection.loadMore();
      this.collection.on('add', _.bind(function(){
        this.emptyViewOff();
      },this));
      this.collection.on('remove stopLoading', this.afterLoad, this);

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

    // this function sets the correct state after loading is done, tries to load more if applicable
    // and sets empty state if we are not loading and we have no items
    afterLoad: function() {
      if(!this.collection._loading) {
        if (this.collection.length === 0) {
          this.emptyViewOn();
        }

        if ( this.bottomOfViewReached()) {
          this.collection.loadMore();
        }
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


    // TODO: replace this by standard empty view functionality by marionette.
    emptyViewOn: function(){},
    emptyViewOff: function(){}

  });
}
window.AutoloadingCompositeView = extendWithAutoloading(Backbone.Factlink.CompositeView);
