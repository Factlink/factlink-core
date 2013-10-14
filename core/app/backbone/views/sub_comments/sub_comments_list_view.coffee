class window.SubCommentsView extends Backbone.Marionette.CollectionView
  className: 'sub-comments'
  emptyView: Backbone.Factlink.EmptyLoadingView
  itemView: SubCommentContainerView

  itemViewOptions: (model) ->
    if model instanceof SubComment
      creator: model.creator()
      innerView: new SubCommentView model: model
    else # emptyView
      collection: @collection

  _initialEvents: ->
    @listenTo @collection, "add remove sync", @render

  initialize: ->
    @collection.fetch()

    if Factlink.Global.signed_in
      @_addViewContainer = new SubCommentContainerView
        creator: currentUser
        innerView: new SubCommentsAddView addToCollection: @collection

  onRender: ->
    return if @collection.loading()

    @closeEmptyView() if @collection.length <= 0

    # Cannot use region as the AddView needs to be sibling in the DOM tree of the other SubCommentContainerViews
    if Factlink.Global.signed_in
      @_renderAddViewContainer()
      @$el.append @_addViewContainer.el

  _renderAddViewContainer: ->
    return if @_addViewContainerRendered

    @_addViewContainer.render()
    @_addViewContainerRendered = true

  onClose: ->
    if Factlink.Global.signed_in
      @_addViewContainer.close()
