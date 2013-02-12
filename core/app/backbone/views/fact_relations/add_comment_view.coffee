class window.AddCommentView extends Backbone.Marionette.ItemView
  className: 'add-comment'
  events:
    'click .js-post': 'addWithHighlight'
    'click .js-switch': 'switchCheckboxClicked'
    'blur  .js-content': 'updateModel'
    'keydown .js-content': 'parseKeyDown'

  template: 'comments/add_comment'

  initialize: ->
    @initializeModel()

  parseKeyDown: (e) =>
    code = e.keyCode || e.which
    @updateModel()
    @addWithHighlight() if code is 13

  addWithHighlight: ->
    @addDefaultModel highlight: true

  initializeModel: ->
    @model = new Comment(content: '', created_by: currentUser)
    @bindTo @model, 'change', @render, @

  templateHelpers: =>
    type_of_action_text: @type_of_action_text()

  type_of_action_text: ->
    if @options.addToCollection.type == 'supporting'
      'Agreeing'
    else
      'Disagreeing'

  updateModel: ->
    content = @$('.js-content').val()
    @model.set {content: content}, silent: true

  setFormContent: (content) -> @model.set content: content

  addModelSuccess: (model) ->
    @initializeModel()
    @alertHide()
    model.trigger 'change'

    mp_track "Factlink: Added comment",
      factlink_id: @options.addToCollection.fact.id
      type: @options.addToCollection.type

  addModelError: -> @alertError()

  switchCheckboxClicked: (e)->
    @trigger 'switch_to_fact_relation_view', @$('.js-content').val()
    e.preventDefault()
    e.stopPropagation()

_.extend AddCommentView.prototype,
  Backbone.Factlink.AddModelToCollectionMixin, Backbone.Factlink.AlertMixin
