nlToBr = (str)-> str.replace(/\n/g, '<br />');

class OneMessageView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'messages/message'

  initialize: ->
    @sender = @model.sender()
    @sender.set(@options.user_collection.get(@sender.id))

  templateHelpers: =>
    sender: @sender.toJSON()
    html_content: nlToBr(htmlEscape(@model.get('content')))

class MessageListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: OneMessageView
  itemViewContainer: 'ul'
  itemViewOptions: ->
    user_collection: @options.user_collection

class window.MessagesView extends Backbone.Marionette.Layout
  className: 'conversation'
  template: 'conversations/conversation'

  regions:
    factRegion: '.fact'
    messagesRegion: '.message-list'

  onRender: ->
    fact = new Fact(id: @model.get('fact_id'))
    fact.fetch
      success: => @factRegion.show new FactView(model: fact)
    @messagesRegion.show new MessageListView(collection: @collection, user_collection: @model.recipients())
