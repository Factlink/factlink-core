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
      created_by: currentUser

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
      placeholder: 'Comment..'

    @listenTo textAreaView, 'focus', @inputFocus, @
    textAreaView

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text('Comment')

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')

class window.SubCommentsAddView extends BaseSubCommentsAddView
  className: 'evidence-sub-comments-form'
  template: 'sub_comments/add_view'

  templateHelpers: => current_user: currentUser.toJSON()

class window.NDPSubCommentsAddView extends BaseSubCommentsAddView

  template:
    text: """
      <div class="js-alert js-alert-error alert alert-error hide">
        Your comment could not be posted, please try again.
        <a class="close" href="#" data-dismiss="alert">x</a>
      </div>

      <div class="ndp-evidenceish-content">
        <div class="js-region-textarea"></div>

        <!-- I don't like this container either, but it was necessary after a weird bug where display: inline-block;
        didn't work on the comment when setting the form to active using Javascript.. -->
        <div class="evidence-sub-comments-button-container">
          <button class="button-blue js-submit">Comment</button>
        </div>
      </div>
    """
