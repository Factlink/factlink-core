window.UserPassportView = Backbone.View.extend({
  tagName: "li",
  className: "user",

  initialize: function(opts) {
    this.model.bind("change", this.render, this);
  },

  render: function() {
    $(this.el).popover();
    return this;
  }

});
