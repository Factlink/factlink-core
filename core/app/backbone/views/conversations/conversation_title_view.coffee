class window.ConversationTitleView extends Backbone.Marionette.Layout
  tagName: "header"
  id: "conversation"
  template: "conversations/detailed_header"

  regions:
    participantsRegion: '.js-participants'

  triggers:
    'click #back-to-conversations-button' : 'showConversations'

  onRender: ->
    @participantsRegion.show new ParticipantsView
      collection: new Backbone.Collection @model.otherRecipients(currentUser)

class ParticipantView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: "conversations/participant"

class window.ParticipantsView extends Backbone.Marionette.CompositeView
  tagName: 'h1'
  className: 'separator-list'
  itemView: ParticipantView
  template: 'conversations/participants'

  appendHtml: (collectionView, itemView) ->
    collectionView.$el.find('.separator-list-item:last').before(itemView.el)
