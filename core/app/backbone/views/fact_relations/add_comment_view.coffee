class window.AddCommentView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin,
                       Backbone.Factlink.AlertMixin

  className: 'add-comment'
  events:
    'click .js-post': 'addWithHighlight'
    'click .js-switch': 'switchCheckboxClicked'
    'keydown .js-content': 'parseKeyDown'

  template: 'comments/add_comment'

  ui:
    content: '.js-content'
    submit:  '.js-post'

  regions:
    avatarRegion: '.js-avatar-region'

  onRender: ->
    @avatarRegion.show new AvatarView(model: currentUser)


  parseKeyDown: (e) =>
    code = e.keyCode || e.which
    @addWithHighlight() if code is 13

  addWithHighlight: ->
    return if @submitting

    @model = new Comment
      content: @formContent()
      created_by: currentUser

    return @addModelError() unless @model.isValid()

    @alertHide()
    @disableSubmit()
    @addDefaultModel highlight: true

  templateHelpers: =>
    type_of_action_text: @type_of_action_text()

  type_of_action_text: ->
    if @options.addToCollection.type == 'supporting'
      'Agreeing'
    else
      'Disagreeing'

  formContent: -> @ui.content.val()

  setFormContent: (content) -> @ui.content.val(content)

  addModelSuccess: (model) ->
    @enableSubmit()
    @setFormContent ''

    model.trigger 'change'

    mp_track "Factlink: Added comment",
      factlink_id: @options.addToCollection.fact.id
      type: @options.addToCollection.type

  addModelError: ->
    @enableSubmit()
    @alertError()

  switchCheckboxClicked: (e)->
    @trigger 'switch_to_fact_relation_view', @$('.js-content').val()
    e.preventDefault()
    e.stopPropagation()

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text('Post comment')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')
