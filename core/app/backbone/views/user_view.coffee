class window.UserView extends Backbone.Marionette.ItemView
  tagName: "article"
  className: "channel-listing-owner-block"
  events:
    "click div.avatar-container": "clickHandler"

  template: "users/user"

  clickHandler: (e) -> @defaultClickHandler e, @model.url()

class window.UserLargeView extends window.UserView
  template: "users/user_large"
