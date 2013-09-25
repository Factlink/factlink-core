class window.ConversationTitleView extends Backbone.Marionette.Layout
  className: 'conversation-title-view'
  template: 'conversations/detailed_header'

  regions:
    participantsRegion: '.js-participants'

  triggers:
    'click #back-to-conversations-button' : 'showConversations'

  onRender: ->
    @participantsRegion.show new ParticipantsView
      collection: new Backbone.Collection @model.otherRecipients(currentUser)
      $offsetParent: @$el

class ParticipantView extends Backbone.Marionette.ItemView
  tagName: 'span'
  className: 'separator-list-item'
  template: 'conversations/participant'

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model,
      $offsetParent: @options.$offsetParent

class window.ParticipantsView extends Backbone.Marionette.CompositeView
  tagName: 'h1'
  className: 'separator-list conversation-participants'
  itemView: ParticipantView
  template: 'conversations/participants'

  itemViewOptions: ->
    $offsetParent: @options.$offsetParent

  appendHtml: (collectionView, itemView) ->
    collectionView.$el.find('.separator-list-item:last').before(itemView.el)
