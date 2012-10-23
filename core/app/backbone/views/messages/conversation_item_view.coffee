class window.ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/item'
  templateHelpers: =>
    url: @model.url()
