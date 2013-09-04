class window.SubCommentsView extends Backbone.Marionette.CollectionView
  className: 'sub-comments'
  emptyView: Backbone.Factlink.EmptyLoadingView
  itemView: SubCommentContainerView

  itemViewOptions: (model) ->
    if model instanceof SubComment
      creator: model.creator()
      innerView: new NDPSubCommentView model: model
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
      @_addViewContainer.render()

  onRender: ->
    return if @collection.loading()

    @closeEmptyView() if @collection.length <= 0

    # The add view needs to be sibling in the DOM tree of the otherSubCommentContainerViews
    @$el.append @_addViewContainer.el if @_addViewContainer?

  onClose: -> @_addViewContainer?.close()
