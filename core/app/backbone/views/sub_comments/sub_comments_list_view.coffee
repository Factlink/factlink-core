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


class window.NDPSubCommentsCollectionView extends Backbone.Marionette.CollectionView
  itemView: NDPSubCommentContainerView

  itemViewOptions: (model) ->
    creator: model.creator()
    innerView: new NDPSubCommentView model: model


class window.NDPSubCommentsView extends Backbone.Marionette.Layout
  template: 'sub_comments/ndp_sub_comments_list'

  regions:
    collectionRegion: '.js-collection-region'
    formRegion: '.js-form-region'

  initialize: ->
    @collection.fetch()

  onRender: ->
    @collectionRegion.show new NDPSubCommentsCollectionView collection: @collection

    addView = new NDPSubCommentsAddView addToCollection: @collection
    @formRegion.show new NDPSubCommentContainerView creator: currentUser, innerView: addView
