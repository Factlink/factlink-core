window.UserView = Backbone.View.extend({

  root: $("#left-column"),
  tagName: "article",
  className: "user-block",
  tmpl: $('#user_block_tmpl').html(),

  events: {
    "click div.avatar-container": "clickHandler"
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
