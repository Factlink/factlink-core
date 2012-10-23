class window.ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: 'conversations/item'
  templateHelpers: =>
    url: @model.url()
