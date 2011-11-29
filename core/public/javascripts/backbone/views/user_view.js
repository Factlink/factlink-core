window.UserView = Backbone.View.extend({

  root: $("#left-column"),
  tagName: "article",
  className: "user-block",
  tmpl: $('#user_block_tmpl').html(),
  
  events: {
    "click div.container": "clickHandler"
  },
  
  render: function() {
    this.el.innerHTML = $.mustache(this.tmpl, this.model.toJSON());
    this.root.prepend( this.el );
    
    return this;
  },
  
  clickHandler: function(e) {
    Router.navigate(this.model.get('username') + "/channels/" + this.model.get('all_channel_id'), true);
  }
});
