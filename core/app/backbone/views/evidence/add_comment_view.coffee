
class window.AddCommentView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.AddModelToCollectionMixin

  className: 'add-comment'
  events:
    'click .js-post': 'addComment'

  template: 'comments/add_comment'

  ui:
    submit:  '.js-post'

  regions:
    inputRegion: '.js-input-region'
    shareFactSelectionRegion: '.js-share-fact-selection-region'

  initialize: ->
    @_textAreaComponent = ReactTextArea
      onChange: (text) =>
        @_textModel().set text: text
      onSubmit: =>
        @addComment()
      defaultValue: @_textModel().get('text')
    @_textAreaView = new ReactView
      component: @_textAreaComponent

  focus: -> @_textAreaComponent.focusInput()

  insert: (text) ->
    @_textAreaComponent.insert text

  onRender: ->
    @inputRegion.show @_textAreaView

    if Factlink.Global.signed_in
      @shareFactSelectionRegion.show @_shareFactSelectionView()

  addComment: ->
    return if @submitting

    @model = new Comment
      content: $.trim(@_textModel().get('text'))
      created_by: currentUser.toJSON()
      type: @options.argumentTypeModel.get 'argument_type'

    return @addModelError() unless @model.isValid()

    @disableSubmit()
    @addDefaultModel()
    @_shareFactlink(@model)

  setFormContent: (content) ->
    @_textModel().set 'text', content
    @_textAreaComponent.updateText('')

  addModelSuccess: (model) ->
    @enableSubmit()
    @setFormContent ''

    mp_track "Factlink: Added comment",
      factlink_id: @options.addToCollection.fact.id
      type: @options.argumentTypeModel.get 'argument_type'

  _shareFactlink: (model) ->
    return unless Factlink.Global.signed_in

    @_shareFactSelectionView().submit model.get('content')

  addModelError: ->
    @enableSubmit()
    FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'

  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text(Factlink.Global.t.post_argument)

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')

  _textModel: -> @__textModel ?= new Backbone.Factlink.SemiPersistentTextModel {},
    key: "add_comment_to_fact_#{@options.addToCollection.fact.id}"

  _shareFactSelectionView: ->
    @___shareFactSelectionView ?= new ShareFactSelectionView
      model: @options.addToCollection.fact
