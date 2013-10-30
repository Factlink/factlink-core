class window.TopFactShareButtonsView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'top-fact-share-buttons'
  template: 'facts/top_fact_share_buttons'

  events:
    'click .js-start-conversation': '_toggleStartConversation'
    'click .js-twitter': '_toggleTwitter'
    'click .js-facebook': '_toggleFacebook'

  templateHelpers: ->
    current_user: currentUser.toJSON()

  _toggleStartConversation: ->
    @_togglePopover '.js-start-conversation', =>
      mp_track 'Factlink: Open conversation popover'

      new StartConversationView(model: @model)

  _toggleTwitter: ->
    @_togglePopover '.js-twitter', =>
      mp_track 'Factlink: Open social share popover (twitter)'

      new PreviewShareFactView model: @model, provider_name: 'twitter'

  _toggleFacebook: ->
    @_togglePopover '.js-facebook', =>
      mp_track 'Factlink: Open social share popover (facebook)'

      new PreviewShareFactView model: @model, provider_name: 'facebook'

  _togglePopover: (selector, contentViewConstructor) ->
    if @popoverExists selector
      @popoverRemove selector
    else
      view = contentViewConstructor()

      @popoverAdd selector,
        side: 'bottom'
        align: 'center'
        fadeTime: 100
        contentView: view

      @listenTo view, 'sent_message', -> @popoverRemove '.js-share'
