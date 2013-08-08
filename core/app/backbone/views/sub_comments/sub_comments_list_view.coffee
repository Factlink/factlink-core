class window.SubCommentsListView extends Backbone.Marionette.CompositeView
  className: 'evidence-sub-comments-list'

  itemView: SubCommentView
  itemViewContainer: '.js-region-sub-comments-collection'

  template: 'sub_comments/sub_comments_list'

  addView: SubCommentsAddView

  initialize: ->
    @collection.fetch update: true # only fires 'add' and 'remove' events

  onShow: ->
    if Factlink.Global.signed_in
      @_subCommentsAddView ?= new @addView(addToCollection: @collection)
      @$('.js-region-sub-comments-form').html @_subCommentsAddView.render().el

  onClose: ->
    @_subCommentsAddView?.close()

class window.NDPSubCommentsListView extends SubCommentsListView
  itemView: NDPSubCommentView
  addView: NDPSubCommentsAddView
