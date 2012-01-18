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

  reInit: function(opts){
    if (!this.model || opts.model.id !== this.model.id) {
      this.close();
      return new UserView(opts);
    } else {
      return this;
    }
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
