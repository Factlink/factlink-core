class window.UserView extends Backbone.Marionette.ItemView
  tagName: "article"
  className: "user-block"
  events:
    "click div.avatar-container": "clickHandler"

  template: "users/_user"
  templateHelpers:
    channel_listing_header: Backbone.Factlink.Global.t.my_channels.capitalize()

  clickHandler: (e) -> Backbone.history.navigate @model.url(), true

class window.UserLargeView extends window.UserView
  template: "users/_user_large"
