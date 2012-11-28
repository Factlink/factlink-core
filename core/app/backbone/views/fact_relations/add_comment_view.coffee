class window.AddCommentView extends Backbone.Marionette.ItemView
  className: 'add-comment'
  events:
    'click .js-post': 'addModel'
    'click .js-switch': 'switchCheckboxClicked'
    'blur  .content': 'updateModel'
    'keyup input.content': 'parseKeyUp'

  template: 'comments/add_comment'

  initialize: ->
    @initializeModel()

  parseKeyUp: (e) =>
    code = e.keyCode || e.which
    switch code
      when 13 then @addModel

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
    content = @$('.content').val()
    @model.set {content: content}, silent: true

  setFormContent: (content) -> @model.set content: content

  showErrorMessage: -> @$('.js-comment-error-message').show()

  addModelSuccess: (model) ->
    @initializeModel()
    model.trigger 'change'

  addModelError: -> @showErrorMessage()

  switchCheckboxClicked: (e)->
    @trigger 'switch_to_fact_relation_view', @$('.content').val()
    e.preventDefault()
    e.stopPropagation()

_.extend AddCommentView.prototype, Backbone.Factlink.AddModelToCollectionMixin
