window.UserView = Backbone.View.extend({
  root: $("#left-column"),
  tagName: "article",
  className: "user-block",

  events: {
    "click div.avatar-container": "clickHandler"
  },

  template:"users/_user",

  render: function() {
    this.el.innerHTML = this.tmpl_render(this.model.toJSON());
    this.root.prepend( this.el );

    return this;
  },

  clickHandler: function(e) {
    Backbone.history.navigate(this.model.url(), true);
  }
});

_.extend(UserView.prototype, TemplateMixin);

window.UserLargeView = window.UserView.extend({
  template: "users/_user_large"
});
