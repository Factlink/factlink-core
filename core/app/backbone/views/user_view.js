window.UserView = Backbone.Marionette.ItemView.extend({
  tagName: "article",
  className: "user-block",

  events: {
    "click div.avatar-container": "clickHandler"
  },

  template:"users/_user",

  templateHelpers: {
    'channel_listing_header': Backbone.Factlink.Global.t.my_channels.capitalize()
  },

  clickHandler: function(e) {
    Backbone.history.navigate(this.model.url(), true);
  }
});


window.UserLargeView = window.UserView.extend({
  template: "users/_user_large"
});
