class window.ConversationItemView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/item'
  events:
    'click' : 'wholeElementClick'

  templateHelpers: =>
    url: @model.url()

  wholeElementClick: (e) ->
    url = @model.url()
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate url, true
