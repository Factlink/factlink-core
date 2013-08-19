class BaseSubCommentsAddView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin,
                       Backbone.Factlink.AlertMixin

  events:
    'click .js-submit': 'submit'

  ui:
    submit: '.js-submit'

  regions:
    textareaRegion: '.js-region-textarea'

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
      created_by: currentUser.toJSON()

    return @addModelError() unless @model.isValid()

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
      placeholder: 'Your comment'

    @listenTo textAreaView, 'focus', @inputFocus, @
    textAreaView

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text(Factlink.Global.t.post_comment)

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')


class window.SubCommentsAddView extends BaseSubCommentsAddView
  className: 'evidence-sub-comments-form'
  template: 'sub_comments/add_view'

  templateHelpers: => current_user: currentUser.toJSON()


class window.NDPSubCommentsAddView extends BaseSubCommentsAddView
  className: 'ndp-evidenceish-content ndp-sub-comments-add'

  template: 'sub_comments/ndp_sub_comments_add'
