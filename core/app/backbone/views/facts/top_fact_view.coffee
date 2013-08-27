class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  events:
    'click .js-repost': 'showRepost'
    'click .js-share': 'showStartConversation'

  regions:
    wheelRegion: '.js-fact-wheel-region'
    userHeadingRegion: '.js-user-heading-region'
    deleteRegion: '.js-delete-region'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  showRepost: ->
    FactlinkApp.ModalWindowContainer.show new AddToChannelModalWindowView(model: @model)

  onRender: ->
    @userHeadingRegion.show new UserInFactHeadingView
        model: @model.user()

    @wheelRegion.show @_wheelView()
    @deleteRegion.show @_deleteButtonView() if @model.can_destroy()

  _deleteButtonView: ->
    deleteButtonView = new DeleteButtonView model: @model
    @listenTo deleteButtonView, 'delete', ->
      @model.destroy
        wait: true
        success: -> mp_track "Factlink: Destroy"
    deleteButtonView

  _wheelView: ->
    wheel = @model.getFactWheel()

    wheel_view_options =
      fact: @model.attributes
      model: wheel
      radius: 45

    if Factlink.Global.signed_in
      wheel_view = new InteractiveWheelView wheel_view_options
    else
      wheel_view = new BaseFactWheelView _.defaults(respondsToMouse: false, wheel_view_options)

    @listenTo @model, 'change', ->
      wheel.setRecursive @model.get("fact_wheel")
      wheel_view.render()

    wheel_view

  showStartConversation: ->
    FactlinkApp.ModalWindowContainer.show new StartConversationModalWindowView(model: @model)
    mp_track "Factlink: Open share modal"
