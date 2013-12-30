class window.AddCommentView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin

  className: 'add-comment'
  events:
    'click .js-post': 'addComment'

  template: 'comments/add_comment'

  ui:
    submit:  '.js-post'

  regions:
    inputRegion: '.js-input-region'
    shareCommentRegion: '.js-share-comment-region'

  initialize: ->
    @_shareCommentView = new ShareCommentView
    @_textAreaView = new Backbone.Factlink.TextAreaView model: @_textModel()
    @listenTo @_textAreaView, 'return', @addComment
    @on 'region:focus', -> @_textAreaView.focusInput()

  onRender: ->
    @inputRegion.show @_textAreaView

    if Factlink.Global.can_haz.share_comment
      @shareCommentRegion.show @_shareCommentView

  addComment: ->
    return if @submitting

    @model = new Comment
      content: @_textModel().get('text')
      created_by: currentUser.toJSON()
      type: @options.argumentTypeModel.get 'argument_type'

    return @addModelError() unless @model.isValid()

    @disableSubmit()
    @addDefaultModel()

  setFormContent: (content) -> @_textModel().set 'text', content

  addModelSuccess: (model) ->
    @enableSubmit()
    @setFormContent ''

    model.trigger 'change'

    mp_track "Factlink: Added comment",
      factlink_id: @options.addToCollection.fact.id
      type: @options.argumentTypeModel.get 'argument_type'

    @_shareFactlink()

  _shareFactlink: ->
    if @_shareCommentView.isSelected 'twitter'
      @options.addToCollection.fact.share 'twitter'
    if @_shareCommentView.isSelected 'facebook'
      @options.addToCollection.fact.share 'facebook'

  addModelError: ->
    @enableSubmit()
    FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text(Factlink.Global.t.post_argument)

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')

  _textModel: -> @__textModel ?= new Backbone.Factlink.SemiPersistentTextModel {},
    key: "add_comment_to_fact_#{@options.addToCollection.fact.id}"
