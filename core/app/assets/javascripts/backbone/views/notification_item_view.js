(function(){
window.NotificationItemView = Backbone.View.extend({
  tagName: "li",
  className: "activity",
  render: function () {
    this.$el.text("Hoi");
    return this;
  }
});
}());