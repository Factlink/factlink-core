class OneMessageView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: 'messages/message'

class window.MessagesView extends Backbone.Marionette.CompositeView
  itemView: OneMessageView
  itemViewContainer: 'ul'
  className: 'conversation'

  template: 'conversations/conversation'
