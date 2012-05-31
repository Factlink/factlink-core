/* easy event handler which just toggles a class on the element of the view */


Backbone.View.prototype.addClassToggle = function(togglename) {
  this[togglename+'On'] = function(){
    this.$el.addClass(togglename);
  };
  this[togglename+'Off'] = function(){
    this.$el.removeClass(togglename);
  };
};