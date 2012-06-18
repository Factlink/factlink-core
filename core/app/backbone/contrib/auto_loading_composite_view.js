window.AutoloadingCompositeView = Backbone.Marionette.CompositeView.extend({
  constructor: function(options){
    Backbone.Marionette.CompositeView.prototype.constructor.apply(this, arguments);
    this.collection.loadMore();
    this.on('add', _.bind(function(){
      this.hideEmpty();
    },this));
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
      if ( this.bottomOfViewReached()) {
        this.collection.loadMore();
      }
    }, this));
  },

  unbindScroll: function() {
    $(window).off('scroll.' + this.cid);
  },

  close: function() {
    Backbone.Marionette.CompositeView.prototype.close.apply(this, arguments);
    this.unbindScroll();
  },

  render: function() {
    Backbone.Marionette.CompositeView.prototype.render.apply(this, arguments);
    this.bindScroll();

    if (this.collection.length === 0 && !this.collection._loading) {
      this.showEmpty();
    }
  },


  reset: function(e){
    this.collection.stopLoading();
    Backbone.Marionette.CompositeView.prototype.reset.apply(this, arguments);
  },

  showEmpty: function(){},
  hideEmpty: function(){}

});
