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

  onRender: ->
    return if @collection.loading()

    @closeEmptyView() if @collection.length <= 0

    if Factlink.Global.signed_in
      # The add view needs to be sibling in the DOM tree of the other SubCommentContainerViews
      @$el.append @addViewContainer().el

  addViewContainer: ->
    unless @_addViewContainer?
      @_addViewContainer = new SubCommentContainerView
        creator: currentUser
        innerView: new SubCommentsAddView addToCollection: @collection

      @_addViewContainer.render()
    @_addViewContainer

  onClose: ->
    if Factlink.Global.signed_in
      @addViewContainer().close()
