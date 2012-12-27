class window.SubCommentsAddView extends Backbone.Marionette.Layout
  className: 'evidence-sub-comments-form'

  template: 'sub_comments/add_view'

  events:
    'click .js-submit': 'submit'

  regions:
    textareaRegion: '.js-region-textarea'

  templateHelpers: => current_user: currentUser.toJSON()

  onRender: ->
    @textareaRegion.show @textAreaView()
    @toggleForm false

  inputFocus: -> @toggleForm true
  inputBlur: -> @toggleForm false if @text().length <= 0

  toggleForm: (active) ->
    @$el.toggleClass 'evidence-sub-comments-form-active', active

  submit: ->
    if @text().length > 0
      @addModel new SubComment
        content: @text()
        created_by: currentUser

  addModelError: -> @alertError()
  addModelSuccess: (model) ->
    @textModel().set 'text', ''
    @alertHide()

  text: -> @textModel().get('text')
  textModel: -> @_textModel ?= new Backbone.Model text: ''
  textAreaView: ->
    textAreaView = new Backbone.Factlink.TextAreaView
      model: @textModel()
      placeholder: 'Comment..'

    @bindTo textAreaView, 'return', @submit, @
    @bindTo textAreaView, 'focus', @inputFocus, @
    @bindTo textAreaView, 'blur', @inputBlur, @
    textAreaView

_.extend SubCommentsAddView.prototype,
  Backbone.Factlink.AddModelToCollectionMixin, Backbone.Factlink.AlertMixin
