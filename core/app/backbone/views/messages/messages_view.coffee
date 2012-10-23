class MessageAvatarView extends Backbone.Marionette.ItemView
  tagName: 'div'
  template: 'messages/user_avatar'


class OneMessageView extends Backbone.Marionette.Layout
  tagName: 'li'
  template: 'messages/message'

  regions:
    avatarRegion: '.avatar'

  onRender: -> @avatarRegion.show new MessageAvatarView(model: @model.sender())

class MessageListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: OneMessageView
  itemViewContainer: 'ul'

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
    @messagesRegion.show new MessageListView(collection: @collection)
