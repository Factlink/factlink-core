class window.SubCommentsAddView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin

  className: 'discussion-evidenceish-content sub-comments-add spec-sub-comments-form'

  template: 'sub_comments/sub_comments_add'

  events:
    'click .js-submit': 'submit'

  ui:
    submit: '.js-submit'

  regions:
    textareaRegion: '.js-region-textarea'

  onRender: ->
    @textareaRegion.show new Backbone.Factlink.TextAreaView
      model: @textModel()
      placeholder: 'Your comment'

  submit: ->
    return if @submitting

    @model = new SubComment
      content: $.trim(@text())
      created_by: currentUser.toJSON()

    return @addModelError() unless @model.isValid()

    @disableSubmit()
    @addDefaultModel()

  addModelSuccess: ->
    @enableSubmit()
    @textModel().set 'text', ''

  addModelError: ->
    @enableSubmit()
    FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'

  text: -> @textModel().get('text')
  textModel: -> @_textModel ?= new Backbone.Model text: ''

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text(Factlink.Global.t.post_comment)

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')

