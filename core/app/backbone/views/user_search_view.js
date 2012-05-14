window.UserSearchView = Backbone.View.extend({
  tagName: "div",
  className: "user-block",

  tmpl: Template.use("users", "_user_search"),

  render: function() {
    this.$el.html( this.tmpl.render( this.model.toJSON()) );

    return this;
  }
});
