class window.TopFactShareButtonsView extends Backbone.Marionette.Layout
  className: 'top-fact-share-buttons'
  template: 'facts/top_fact_share_buttons'

  templateHelpers: ->
    current_user: currentUser.toJSON()

  onRender: ->
    @_renderPopover '.js-start-conversation', =>
      mp_track 'Factlink: Open conversation popover'
      new StartConversationView(model: @model)

    @_renderPopover '.js-twitter', =>
      mp_track 'Factlink: Open social share popover (twitter)'
      new PreviewShareFactView model: @model, provider_name: 'twitter'

    @_renderPopover '.js-facebook', =>
      mp_track 'Factlink: Open social share popover (facebook)'
      new PreviewShareFactView model: @model, provider_name: 'facebook'

  _renderPopover: (selector, contentViewConstructor) ->
    Backbone.Factlink.makeTooltipForView @,
      stayWhenHoveringTooltip: true
      hoverIntent: true
      positioning: {align: 'right', side: 'bottom'}
      selector: selector
      tooltipViewFactory: =>
        view = contentViewConstructor()
        @listenTo view, 'success', @render
        view
