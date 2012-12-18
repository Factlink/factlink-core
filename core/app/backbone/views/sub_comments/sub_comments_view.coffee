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

class SubCommentsListView extends Backbone.Marionette.CollectionView
  className: 'evidence-sub-comments-list'
  itemView: SubCommentView

class SubCommentsAddView extends Backbone.Marionette.ItemView
  className: 'evidence-sub-comments-form'

  template:
    text: """
        <div class="js-alert js-alert-error alert alert-error hide">
          Your comment could not be posted, please try again.
          <a class="close" href="#" data-dismiss="alert">x</a>
        </div>

        <img class="evidence-sub-comments-avatar" src="{{ current_user.avatar_url_32 }}" height="32" width="32">
        <textarea class="evidence-sub-comments-textarea js-input" placeholder="Comment.."></textarea>

        <!-- I don't like this container either, but it was necessary after a weird bug where display: inline-block;
        didn't work on the comment when setting the form to active using Javascript.. -->
        <div class="evidence-sub-comments-button-container">
          <button class="evidence-sub-comments-button btn btn-primary pull-right js-submit">Comment</button>
        </div>
    """

  events:
    'click .js-input': 'inputClick'
    'blur .js-input': 'inputBlur'
    'keydown .js-input': 'parseKeyDown'
    'click .js-submit': 'submit'

  templateHelpers: => current_user: currentUser.toJSON()

  onRender: -> @toggleForm false

  inputClick: -> @toggleForm true
  inputBlur: -> @toggleForm false if @$('.js-input').val().length <= 0

  toggleForm: (active) ->
    @$el.toggleClass 'evidence-sub-comments-form-active', active

  parseKeyDown: (e) =>
    code = e.keyCode || e.which
    if code is 13
      @submit()
      e.preventDefault()

  submit: ->
    @addModel new SubComment
      content: @$('.js-input').val()
      created_by: currentUser

  addModelSuccess: (model) ->
    @initializeModel()
    @alertHide()

  addModelError: -> @alertError()

_.extend SubCommentsAddView.prototype,
  Backbone.Factlink.AddModelToCollectionMixin, Backbone.Factlink.AlertMixin

class window.SubCommentsView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comments'

  template:
    text: """
      <div class="evidence-sub-comments-link"><a class="js-sub-comments-link"></a></div>
      <div class="js-sub-comments-list-container evidence-sub-comments-list-container hide">
        <div class="evidence-sub-comments-arrow"></div>
        <div class="js-region-sub-comments-list"></div>
        <div class="js-region-sub-comments-form"></div>
      </div>
    """

  regions:
    subCommentsList: '.js-region-sub-comments-list'
    subCommentsForm: '.js-region-sub-comments-form'

  events:
    'click .js-sub-comments-link': 'toggleList'

  onRender: ->
    @updateLink()
    # Bind to model change event here when returning a comment count

  toggleList: ->
    if @listOpen then @closeList()
    else @openList()

  openList: ->
    subComments = @subComments()
    # add subcomments fetch here

    $('.js-sub-comments-list-container').removeClass('hide')
    @subCommentsList.show new SubCommentsListView collection: subComments
    @subCommentsForm.show new SubCommentsAddView addToCollection: subComments

    @listOpen = true

  closeList: ->
    $('.js-sub-comments-list-container').addClass('hide')
    @subCommentsList.close()
    @listOpen = false

  subComments: ->
    @_subComments ?= new SubComments([
        new SubComment(text: 'hihihi', created_by: {username: 'joel', gravatar_hash: '781e915f298de5951e77813cc8f328a9', authority: '3.4'}),
        new SubComment(text: 'hahahaha', created_by: {username: 'tomdev', gravatar_hash: '88e950aeccc17b8d02be83ca18f8232b', authority: '24'})
      ], parentModel: @model)

  updateLink: ->
    @$(".js-sub-comments-link").text "Comments" # Add comment count here
