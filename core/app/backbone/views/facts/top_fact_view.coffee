class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  events:
    'click .js-repost': 'showRepost'

  regions:
    wheelRegion: '.js-fact-wheel-region'
    userHeadingRegion: '.js-user-heading-region'
    userRegion: '.js-user-name-region'
    deleteRegion: '.js-delete-region'
    shareRegion: '.js-share-region'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  showRepost: ->
    FactlinkApp.ModalWindowContainer.show new AddToChannelModalWindowView(model: @model)

  onRender: ->
    heading_view = if @model.get("proxy_scroll_url")
        new TopFactHeadingLinkView model: @model
      else
        new TopFactHeadingUserView model: @model.user()
    @userHeadingRegion.show heading_view

    @userRegion.show new UserInTopFactView
        model: @model.user()
        $offsetParent: @$el

    @wheelRegion.show @_wheelView()
    @deleteRegion.show @_deleteButtonView() if @model.can_destroy()

    if Factlink.Global.signed_in
      @shareRegion.show new TopFactShareButtonsView model: @model

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
