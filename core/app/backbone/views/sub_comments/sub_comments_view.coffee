class SubCommentsListView extends Backbone.Marionette.CollectionView
  className: 'evidence-sub-comments-list'
  itemView: SubCommentView

class window.SubCommentsView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comments'

  template: 'sub_comments/sub_comments'

  regions:
    subCommentsListRegion: '.js-region-sub-comments-list'
    subCommentsFormRegion: '.js-region-sub-comments-form'

  events:
    'click .js-sub-comments-link': 'toggleList'

  onRender: ->
    @bindTo @model, 'change:sub_comments_count', @updateLink, @
    @updateLink()

  toggleList: -> if @listOpen then @closeList() else @openList()

  openList: ->
    @listOpen = true
    @$('.js-sub-comments-list-container').removeClass('hide')

    subComments = new SubComments([], parentModel: @model)
    subComments.fetch update: true # only fires 'add' and 'remove' events

    @subCommentsFormRegion.show new SubCommentsAddView addToCollection: subComments
    @subCommentsListRegion.show new SubCommentsListView collection: subComments

  closeList: ->
    @listOpen = false
    @$('.js-sub-comments-list-container').addClass('hide')
    @subCommentsFormRegion.close()
    @subCommentsListRegion.close()

  updateLink: ->
    count = @model.get('sub_comments_count')

    count_str = ""

    if count
      count_str = " (#{count})"

    @$(".js-sub-comments-link").text "Comments#{count_str}"
