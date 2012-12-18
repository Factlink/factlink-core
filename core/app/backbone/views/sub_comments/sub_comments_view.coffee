class SubCommentView extends Backbone.Marionette.ItemView
  className: 'evidence-sub-comment'

  template:
    text: """
      <img class="evidence-sub-comments-avatar" src="{{ creator.avatar_url_32 }}" height="32" width="32">
      <div class="evidence-sub-comment-author">
        <strong>
          <a href="/{{ creator.username }}" rel="backbone">{{ creator.username }}</a>
        </strong>
        ( <img src="{{global.brain_image}}"> <span class="evidence-sub-comment-authority">{{ creator.authority }}</span> )
      </div>
      <div class="evidence-sub-comment-content">{{text}}</div>
    """

  templateHelpers: => creator: @model.creator().toJSON()

class SubCommentsListView extends Backbone.Marionette.CompositeView
  className: 'evidence-sub-comments-list'
  itemView: SubCommentView
  itemViewContainer: '.js-item-view-container'

  template:
    text: """
      <div class="evidence-sub-comments-arrow"></div>
      <div class="js-item-view-container"></div>
      <div class="evidence-sub-comments-form">
        <img class="evidence-sub-comments-avatar" src="{{ current_user.avatar_url_32 }}" height="32" width="32">
        <textarea class="evidence-sub-comments-textarea js-input" placeholder="Comment.."></textarea>

        <!-- I don't like this container either, but it was necessary after a weird bug where display: inline-block;
        didn't work on the comment when setting the form to active using Javascript.. -->
        <div class="evidence-sub-comments-button-container">
          <button class="evidence-sub-comments-button btn btn-primary pull-right js-post">Comment</button>
        </div>
      </div>
    """

  events:
    'click .js-input': 'inputClick'
    'blur .js-input': 'inputBlur'

  onRender: -> @toggleForm false

  inputClick: -> @toggleForm true
  inputBlur: -> @toggleForm false if @$('.js-input').val().length <= 0

  toggleForm: (active) ->
    @$('.evidence-sub-comments-form').toggleClass('evidence-sub-comments-form-active', active)

  templateHelpers: => current_user: currentUser.toJSON()

class window.SubCommentsView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comments'

  template:
    text: """
      <div class="evidence-sub-comments-link"><a class="js-sub-comments-link"></a></div>
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
      collection: new SubComments([
        new SubComment(text: 'hihihi', created_by: {username: 'joel', gravatar_hash: '781e915f298de5951e77813cc8f328a9', authority: '3.4'}),
        new SubComment(text: 'hahahaha', created_by: {username: 'tomdev', gravatar_hash: '88e950aeccc17b8d02be83ca18f8232b', authority: '24'})
      ], parentModel: @model)

    @listOpen = true

  closeList: ->
    @subCommentsList.close()
    @listOpen = false

  updateLink: ->
    @$(".js-sub-comments-link").text "Comments" # Add comment count here
