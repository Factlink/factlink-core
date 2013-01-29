class window.SubCommentsListView extends Backbone.Marionette.CompositeView
  className: 'evidence-sub-comments-list'

  itemView: SubCommentView
  itemViewContainer: '.js-region-sub-comments-collection'

  template: 'sub_comments/sub_comments_list'

  initialize: ->
    @collection.fetch update: true # only fires 'add' and 'remove' events

  onShow: ->
    @$('.js-region-sub-comments-form').html @subCommentsAddView().render().el

  onClose: ->
    @subCommentsAddView().close()

  subCommentsAddView: ->
    @_subCommentsAddView ?= new SubCommentsAddView(addToCollection: @collection)
