class window.AddCommentView extends Backbone.Marionette.ItemView
  className: 'add-comment'
  events:
    'click .submit': 'addModel'
    'click .js-switch': 'switchCheckboxClicked'
    'blur  .content': 'updateModel'
    'keyup input.content': 'parseKeyUp'

  template: 'comments/add_comment'

  initialize: ->
    @initializeModel()
    @bindTo @model, 'change', @render, @

  parseKeyUp: (e) ->
    code = e.keyCode || e.which
    switch e.keyCode
      when 13 then @addModel()

  initializeModel: ->
    @model = new Comment(content: '', created_by: currentUser)

  templateHelpers: =>
    type_of_action_text: @type_of_action_text()

  type_of_action_text: ->
    if @options.addToCollection.type == 'believes'
      'Agreeing'
    else
      'Disagreeing'

  updateModel: ->
    content = @$('.content').val()
    @model.set {content: content}, silent: true

  clearForm: -> @setFormContent ''

  setFormContent: (content) -> @model.set content: content

  showErrorMessage: -> @$('.js-comment-error-message').show()

  addModelSuccess: (model) ->
    @initializeModel()
    @clearForm()
    model.trigger 'change'

  addModelError: -> @showErrorMessage()

  switchCheckboxClicked: (e)->
    @trigger 'switch_to_fact_relation_view', @$('.content').val()
    e.preventDefault()
    e.stopPropagation()

_.extend AddCommentView.prototype, Backbone.Factlink.AddModelToCollectionMixin
