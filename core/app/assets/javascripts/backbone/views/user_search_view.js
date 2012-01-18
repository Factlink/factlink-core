window.UserSearchView = Backbone.View.extend({
  tagName: "div",
  className: "user-block",

  events: {
    "click div.avatar-container": "clickHandler"
  },
  
  initialize: function() {
    this.useTemplate("users", "_user_search");
  },

  render: function() {
    $(this.el).html( Mustache.to_html(this.tmpl, this.model.toJSON()) );

    return this;
  },

  clickHandler: function(e) {
    document.location.href = this.model.url();
  }
});
