window.UserView = Backbone.View.extend({
  root: $("#left-column"),
  tagName: "article",
  className: "user-block",

  events: {
    "click div.avatar-container": "clickHandler"
  },
  
  initialize: function() {
    this.useTemplate("users", "_user");
  },

  render: function() {
    this.el.innerHTML = Mustache.to_html(this.tmpl, this.model.toJSON());
    this.root.prepend( this.el );

    return this;
  },

  clickHandler: function(e) {
    Router.navigate(this.model.url(), true);
  }
});
