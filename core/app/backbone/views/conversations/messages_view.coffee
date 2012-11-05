class OneMessageView extends Backbone.Marionette.ItemView
  tagName: 'li'
  className: 'clearfix'
  template: 'conversations/message'

  initialize: ->
    @sender = @model.sender()
    @sender.set(@options.user_collection.get(@sender.id))
    @bindTo(@model, "scroll", @scroll); # Remove this line when upgrading Marionette, as the new version uses @modelEvents

  templateHelpers: =>
    sender: @sender.toJSON()
    html_content: nlToBr(htmlEscape(@model.get('content')))

  modelEvents: ->
    'scroll': 'scroll'

  scroll: ->
    $.scrollTo $(@el).offset().top - 72 , 800

class MessageListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  itemView: OneMessageView
  itemViewContainer: 'ul'

  itemViewOptions: ->
    user_collection: @options.user_collection

class NoFactView extends Backbone.Marionette.ItemView
  template: "conversations/no_fact"

class window.MessagesView extends Backbone.Marionette.Layout
  className: 'conversation'
  template: 'conversations/conversation'

  regions:
    factRegion: '.fact-wrapper'
    messagesRegion: '.messages'
    replyRegion: '.reply'

  initialEvents: -> # Remove this line when updating Marionette
    # Right now removing this line does not break anything, but in the future it might
    # (If Marionette is not updated.)
    # In our version of Marionette a Layout re-renders when its @collection gets a 'reset' event
    # At the moment it only receives "add" and "change" events, but if we choose to update the
    # conversations using @collection.fetch, this entire view (including fact, etc.) would re-render
    # See: https://github.com/chancancode/marionette-rails/blob/9647f1bfe217c05b1ebb69cba889ae0abf4ea980/vendor/assets/javascripts/backbone.marionette.js#L234

  onRender: ->
    @showFact()
    @messagesRegion.show new MessageListView(collection: @collection, user_collection: @model.recipients())
    @replyRegion.show new ConversationReplyView(model: @model)

  showFact: ->
    error = => @factRegion.show new NoFactView
    success = => @factRegion.show new FactView(model: fact)
    if fact_id = @model.get('fact_id')
      fact = new Fact(id: fact_id)
      fact.fetch success: success, error: error
    else
      error()
