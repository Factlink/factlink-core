class window.TopFactShareButtonsView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  tagName: 'ul'
  className: 'top-fact-share-buttons'
  template: 'facts/top_fact_share_buttons'

  events:
    'click .js-share': '_toggleConversation'

  _toggleConversation: ->
    if @popoverExists '.js-share'
      @popoverRemove '.js-share'
    else
      @popoverAdd '.js-share',
        side: 'bottom'
        align: 'center'
        fadeTime: 100
        contentView: @_newStartConversationView()
      mp_track "Factlink: Toggle conversation popover"

  _newStartConversationView: ->
    view = new StartConversationView(model: @model)
    @listenTo view, 'sent_message', -> @popoverRemove '.js-share'
    view
