function extendWithPopover(superclass) {
  return superclass.extend({
    constructor: function(options) {
      superclass.prototype.constructor.apply(this, arguments);

      if ( ! _.isArray( this.popover ) ) return;

      _.each( this.popover, this.bindPopover, this );

      this.on('render', this.realOnRender, this);
    },

    bindPopover: function ( obj, key ) {
      var method = _.bind(this.popoverToggle, this, obj, key);
      var blockMethod = function (e) {
        e.stopPropagation();
      };

      this.$el.on("click.popover", obj.selector, method);
      this.$el.on("click.popover_menu", obj.popoverSelector, blockMethod);
    },

    realOnRender: function () {
      if ( ! _.isArray( this.popover ) ) return;

      _.each( this.popover, this.onRenderPopover, this );
    },

    onRenderPopover: function (obj, key) {
      if ( this.$el.find( obj.popoverSelector ).children('li').length <= 0 ) {
        this.$el.find( obj.selector ).hide();
      }
    },

    popoverToggle: function (obj, key, e) {
      var $popover = this.$el.find(obj.popoverSelector);

      if ( $popover.is(':hidden') ) {
        this.showPopover($popover, obj, key);
      } else {
        this.hidePopover($popover, obj, key);
      }
    },

    showPopover: function ($popover, obj, key) {
      var $popoverButton = this.$el.find(obj.selector);

      $popover.show();

      $popoverButton.addClass('active');

      this.bindWindowClick($popover, obj, key);
    },

    hidePopover: function ($popover, obj, key) {
      var $popoverButton = this.$el.find(obj.selector);

      $popover.hide();

      $popoverButton.removeClass('active');

      this.unbindWindowClick(key);
    },

    bindWindowClick: function ($popover, obj, key) {
      $(window).on('click.popover.' + this.cid + '.' + key, _.bind(function (e) {
        if ( $( e.target ).closest(obj.selector)[0] !== this.$el.find(obj.selector)[0] ) {
          this.hidePopover($popover, obj, key);
        }
      }, this));
    },

    unbindWindowClick: function (key) {
      $(window).off('click.popover.' + this.cid + '.' + key);
    },

    close: function () {
      superclass.prototype.close.apply(this, arguments);
      this.$el.off("click.popover");
    }
  });
}
Backbone.Factlink.PopoverView = extendWithPopover(Backbone.Marionette.ItemView);
