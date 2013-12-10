class window.AddCommentView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin

  className: 'add-comment'
  events:
    'click .js-post': 'addComment'
    'click .js-switch-to-factlink': 'switchToFactRelation'

  template: 'comments/add_comment'

  ui:
    submit:  '.js-post'

  regions:
    inputRegion: '.js-input-region'

  onRender: ->
    @inputRegion.show @_textAreaView()

  addComment: ->
    return if @submitting

    @model = new Comment
      content: @_textModel().get('text')
      created_by: currentUser.toJSON()
      type: @options.type

    return @addModelError() unless @model.isValid()

    @disableSubmit()
    @addDefaultModel()

  setFormContent: (content) -> @_textModel().set 'text', content

  addModelSuccess: (model) ->
    @enableSubmit()
    @setFormContent ''

    model.trigger 'change'
    @options.addToCollection.trigger 'saved_added_model'

    mp_track "Factlink: Added comment",
      factlink_id: @options.addToCollection.fact.id
      type: @options.type

  addModelError: ->
    @enableSubmit()
    FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'
    @options.addToCollection.trigger 'error_adding_model'

  switchToFactRelation: ->
    @trigger 'switch_to_fact_relation_view'

    mp_track "Evidence: Switching to FactRelation"

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text(Factlink.Global.t.post_comment)

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')

  _textModel: -> @__textModel ?= new Backbone.Factlink.SemiPersistentTextModel {},
    key: "add_comment_to_fact_#{@options.addToCollection.fact.id}"

  _textAreaView: ->
    @__textAreaView ?= new Backbone.Factlink.TextAreaView
      model: @_textModel()
      placeholder: 'Comment...'
