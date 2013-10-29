class window.TopFactShareButtonsView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  tagName: 'ul'
  className: 'top-fact-share-buttons'
  template: 'facts/top_fact_share_buttons'

  events:
    'click .js-share': ->
      @_togglePopover '.js-share', '_newStartConversationView'
      mp_track "Factlink: Toggle conversation popover"

  _togglePopover: (selector, contentViewConstructor) ->
    if @popoverExists selector
      @popoverRemove selector
    else
      @popoverAdd selector,
        side: 'bottom'
        align: 'center'
        fadeTime: 100
        contentView: @[contentViewConstructor]()

  _newStartConversationView: ->
    view = new StartConversationView(model: @model)
    @listenTo view, 'sent_message', -> @popoverRemove '.js-share'
    view
