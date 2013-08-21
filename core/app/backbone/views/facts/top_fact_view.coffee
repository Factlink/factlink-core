class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  events:
    'click .js-repost': 'showRepost'
    'click .js-share': 'showStartConversation'

  regions:
    wheelRegion: '.js-fact-wheel-region'
    userHeadingRegion: '.js-user-heading-region'

  showRepost: ->
    FactlinkApp.Modal.show 'Repost Factlink',
      new AddToChannelModalView(model: @model)

  onRender: ->
    @userHeadingRegion.show new UserInFactHeadingView
        model: @model.user()

    @wheelRegion.show @wheelView()

  wheelView: ->
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
    FactlinkApp.Modal.show 'Send a message',
      new StartConversationView(model: @model)

    mp_track "Factlink: Open share modal"
