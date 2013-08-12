class BaseSubCommentsListView extends Backbone.Marionette.CompositeView
  itemView: SubCommentView
  itemViewContainer: '.js-region-sub-comments-collection'

  template: 'sub_comments/sub_comments_list'

  initialize: ->
    @collection.fetch update: true # only fires 'add' and 'remove' events

  onShow: ->
    if Factlink.Global.signed_in
      @$('.js-region-sub-comments-form').html @subCommentsAddView().render().el

  onClose: ->
    @subCommentsAddView().close()


class window.SubCommentsListView extends BaseSubCommentsListView
  className: 'evidence-sub-comments-list'

  subCommentsAddView: ->
    @_subCommentsAddView ?= new SubCommentsAddView(addToCollection: @collection)


class window.NDPSubCommentsListView extends BaseSubCommentsListView
  itemView: NDPSubCommentView
  template: 'sub_comments/ndp_sub_comments_list'

  subCommentsAddView: ->
    @_subCommentsAddView ?= new NDPSubCommentsAddView(addToCollection: @collection)
