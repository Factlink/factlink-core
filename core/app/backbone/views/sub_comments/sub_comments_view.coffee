class SubCommentView extends Backbone.Marionette.ItemView
  template:
    text: """
      <img src="{{ creator.avatar_url_32 }}" height="32" width="32">
      <div>
        <strong>
          <a href="/{{ creator.username }}" rel="backbone">{{ creator.username }}</a>
        </strong>
        ( <img src="{{global.brain_image}}"> <span class="">{{ creator.authority }}</span> )
      </div>
      {{text}}
    """

  templateHelpers: => creator: @model.creator().toJSON()

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
      collection: new SubComments [
        new SubComment(text: 'hihihi', created_by: {username: 'joel', gravatar_hash: '781e915f298de5951e77813cc8f328a9', authority: '3.4'}),
        new SubComment(text: 'hahahaha', created_by: {username: 'tomdev', gravatar_hash: '88e950aeccc17b8d02be83ca18f8232b', authority: '24'})
      ]
    @listOpen = true

  closeList: ->
    @subCommentsList.close()
    @listOpen = false

  updateLink: ->
    @$(".js-sub-comments-link").text "Comments" # Add comment count here
