class window.UserView extends Backbone.Marionette.ItemView
  tagName: "article"
  className: "user-block"
  events:
    "click div.avatar-container": "clickHandler"

  template: "users/user"

  clickHandler: (e) -> Backbone.history.navigate @model.url(), true

class window.UserLargeView extends window.UserView
  template: "users/user_large"
