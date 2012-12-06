class window.AddCommentView extends Backbone.Marionette.ItemView
  className: 'add-comment'
  events:
    'click .js-post': 'addDefaultModel'
    'click .js-switch': 'switchCheckboxClicked'
    'blur  .js-content': 'updateModel'
    'keydown .js-content': 'parseKeyDown'

  template: 'comments/add_comment'

  initialize: ->
    @initializeModel()

  parseKeyDown: (e) =>
    code = e.keyCode || e.which
    @addDefaultModel() if code is 13

  initializeModel: ->
    @model = new Comment(content: '', created_by: currentUser)
    @bindTo @model, 'change', @render, @

  templateHelpers: =>
    type_of_action_text: @type_of_action_text()

  type_of_action_text: ->
    if @options.addToCollection.type == 'believes'
      'Agreeing'
    else
      'Disagreeing'

  updateModel: ->
    content = @$('.js-content').val()
    @model.set {content: content}, silent: true

  setFormContent: (content) -> @model.set content: content

  showErrorMessage: -> @$('.js-comment-error-message').show()

  addModelSuccess: (model) ->
    @initializeModel()
    model.trigger 'change'

  addModelError: -> @showErrorMessage()

  switchCheckboxClicked: (e)->
    @trigger 'switch_to_fact_relation_view', @$('.js-content').val()
    e.preventDefault()
    e.stopPropagation()

_.extend AddCommentView.prototype, Backbone.Factlink.AddModelToCollectionMixin
