class window.UserView extends Backbone.Marionette.ItemView
  tagName: "article"
  className: "channel-listing-owner-block"
  template: "users/user"

class window.UserLargeView extends window.UserView
  template: "users/user_large"
