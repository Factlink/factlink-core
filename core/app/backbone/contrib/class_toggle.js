/* easy event handler which just toggles a class on the element of the view */


_.extend(Backbone.View.prototype,{
  addClassToggle: function(togglename) {
    this[togglename+'On'] = function(){
      console.info(this.model.get('title'));
      console.info(this.$el);
      this.$el.addClass(togglename);
    };
    this[togglename+'Off'] = function(){
      console.info(this.model.get('title'));
      console.info(this.$el);
      this.$el.removeClass(togglename);
    };
  }
})