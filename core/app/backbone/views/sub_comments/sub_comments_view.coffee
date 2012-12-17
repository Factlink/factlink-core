class SubCommentView extends Backbone.Marionette.ItemView
  template:
    text: """
      {{text}}
    """

class SubCommentsListView extends Backbone.Marionette.CollectionView
  itemView: SubCommentView

class window.SubCommentsView extends Backbone.Marionette.Layout
  template:
    text: """
      <div><a class="js-sub-comments-link"></a></div>
      <div class="js-region-sub-comments-list"></div>
    """

  regions:
    subCommentsList: '.js-region-sub-comments-list'

  events:
    'click .js-sub-comments-link': 'toggleList'

  onRender: ->
    @updateLink()
    # Bind to model change event here when returning a comment count

  toggleList: ->
    if @listOpen then @closeList()
    else @openList()

  openList: ->
    @subCommentsList.show new SubCommentsListView
      collection: new SubComments [new SubComment(text: 'henk'), new SubComment(text: 'hahahaha')]
    @listOpen = true

  closeList: ->
    @subCommentsList.close()
    @listOpen = false

  updateLink: ->
    @$(".js-sub-comments-link").text "Comments" # Add comment count here
