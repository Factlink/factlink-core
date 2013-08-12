class window.SubCommentsListView extends Backbone.Marionette.CompositeView
  className: 'evidence-sub-comments-list'
  itemView: SubCommentView
  itemViewContainer: '.js-region-sub-comments-collection'

  template: 'sub_comments/sub_comments_list'

  initialize: ->
    @collection.fetch()

  onShow: ->
    if Factlink.Global.signed_in
      @_subCommentsAddView ?= new SubCommentsAddView(addToCollection: @collection)
      @$('.js-region-sub-comments-form').html @_subCommentsAddView().render().el

  onClose: ->
    @_subCommentsAddView?.close()


class window.NDPSubCommentsView extends Backbone.Marionette.CollectionView
  className: 'ndp-sub-comments'

  itemView: NDPSubCommentContainerView

  itemViewOptions: (model) ->
    creator: model.creator()
    innerView: new NDPSubCommentView model: model

  _initialEvents: ->
    @listenTo @collection, "add remove reset", @render

  initialize: ->
    @collection.fetch()

    if Factlink.Global.signed_in
      @_addViewContainer = new NDPSubCommentContainerView
        creator: currentUser
        innerView: new NDPSubCommentsAddView addToCollection: @collection
      @_addViewContainer.render()

  onRender: ->
    # The add view needs to be sibling in the DOM tree of the otherSubCommentContainerViews
    @$el.append @_addViewContainer.el if @_addViewContainer?

  onClose: -> @_addViewContainer?.close()
