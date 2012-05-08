window.UserSearchView = Backbone.View.extend({
  tagName: "div",
  className: "user-block",

  events: {
    "click div.list-block": "clickHandler"
  },

  tmpl: Template.use("users", "_user_search"),

  render: function() {
    this.$el.html( this.tmpl.render( this.model.toJSON()) );

    return this;
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  }
});
