class window.TopFactView extends Backbone.Marionette.Layout
  className: 'top-fact'

  template: 'facts/top_fact'

  events:
    'click .js-repost': 'showRepost'

  regions:
    userHeadingRegion: '.js-user-heading-region'
    userRegion: '.js-user-name-region'
    deleteRegion: '.js-delete-region'
    shareRegion: '.js-share-region'

  templateHelpers: =>
    showDelete: @model.can_destroy()

  showRepost: ->
    FactlinkApp.ModalWindowContainer.show new AddToChannelModalWindowView(model: @model)

  onRender: ->
    if @model.get("proxy_scroll_url")
      @userHeadingRegion.show new TopFactHeadingLinkView model: @model
    else
      @userHeadingRegion.show new TopFactHeadingUserView model: @model.user()

    @userRegion.show new UserInTopFactView
        model: @model.user()
        $offsetParent: @$el

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
