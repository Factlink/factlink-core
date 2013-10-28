class TopFactShareButtonsView extends Backbone.Marionette.Layout
  template:
    text: """
      {{#global.can_haz.share_discussion_buttons}}
        <li class="top-fact-share-buttons-option"><a class="share-button share-discussion-button share-button-facebook" href="javascript:void(0)">Facebook</a></li>
        <li class="top-fact-share-buttons-option"><a class="share-button share-discussion-button share-button-twitter" href="javascript:void(0)">Twitter</a></li>
      {{/global.can_haz.share_discussion_buttons}}

      {{#global.signed_in}}
        <li class="top-fact-share-buttons-option"><a class="share-button share-discussion-button share-button-message js-share" href="javascript:void(0)">Share</a></li>
      {{/global.signed_in}}
    """

  tagName: 'ul'
  className: 'top-fact-share-buttons'

  events:
    'click .js-share': 'showStartConversation'

  showStartConversation: ->
    FactlinkApp.ModalWindowContainer.show new StartConversationModalWindowView(model: @model)
    mp_track "Factlink: Open share modal"


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
