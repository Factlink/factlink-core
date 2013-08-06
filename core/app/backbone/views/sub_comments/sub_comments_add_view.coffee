class window.SubCommentsAddView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin,
                       Backbone.Factlink.AlertMixin

  className: 'evidence-sub-comments-form'

  template: 'sub_comments/add_view'

  events:
    'click .js-submit': 'submit'

  regions:
    textareaRegion: '.js-region-textarea'

  ui:
    submit: '.js-submit'

  templateHelpers: => current_user: currentUser.toJSON()

  onRender: ->
    @textareaRegion.show @textAreaView()
    @toggleForm false

  inputFocus: -> @toggleForm true

  toggleForm: (active) ->
    @$el.toggleClass 'evidence-sub-comments-form-active', active

  submit: ->
    return if @submitting

    @model = new SubComment
      content: $.trim(@text())
      created_by: currentUser

    @alertHide()
    @disableSubmit()
    @addDefaultModel()

  addModelSuccess: ->
    @enableSubmit()
    @textModel().set 'text', ''

  addModelError: ->
    @enableSubmit()
    @alertError()

  text: -> @textModel().get('text')
  textModel: -> @_textModel ?= new Backbone.Model text: ''
  textAreaView: ->
    textAreaView = new Backbone.Factlink.TextAreaView
      model: @textModel()
      placeholder: 'Comment..'

    @listenTo textAreaView, 'focus', @inputFocus, @
    textAreaView

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text('Comment')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')
