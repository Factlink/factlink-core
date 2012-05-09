window.UserView = Backbone.View.extend({
  root: $("#left-column"),
  tagName: "article",
  className: "user-block",

  events: {
    "click div.avatar-container": "clickHandler"
  },

  tmpl: Template.use("users", "_user"),

  reInit: function(opts){
    if (!this.model || opts.model.id !== this.model.id) {
      this.close();
      return new UserView(opts);
    } else {
      return this;
    }
  },

  render: function() {
    this.el.innerHTML = this.tmpl.render(this.model.toJSON());
    this.root.prepend( this.el );

    return this;
  },

  clickHandler: function(e) {
    Backbone.history.navigate(this.model.url(), true);
  }
});
