class BaseSubCommentsListView extends Backbone.Marionette.CompositeView
  itemViewContainer: '.js-region-sub-comments-collection'

  template: 'sub_comments/sub_comments_list'

  initialize: ->
    @collection.fetch()

  onShow: ->
    if Factlink.Global.signed_in
      @$('.js-region-sub-comments-form').html @subCommentsAddView().render().el

  onClose: ->
    @subCommentsAddView().close()


class window.SubCommentsListView extends BaseSubCommentsListView
  className: 'evidence-sub-comments-list'
  itemView: SubCommentView

  subCommentsAddView: ->
    @_subCommentsAddView ?= new SubCommentsAddView(addToCollection: @collection)


class window.NDPSubCommentsListView extends BaseSubCommentsListView
  template: 'sub_comments/ndp_sub_comments_list'
  itemView: NDPSubCommentContainerView

  subCommentsAddView: ->
    addView = new NDPSubCommentsAddView(addToCollection: @collection)
    @_subCommentsAddView ?= new NDPSubCommentContainerView creator: currentUser, innerView: addView

  itemViewOptions: (model) ->
    creator: model.creator()
    innerView: new NDPSubCommentView model: model
