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
    @_textAreaView = new Backbone.Factlink.TextAreaView model: @_textModel()
    @listenTo @_textAreaView, 'return', @addComment
    @on 'region:focus', -> @_textAreaView.focusInput()

  onRender: ->
    @inputRegion.show @_textAreaView

    if Factlink.Global.can_haz.share_comment && Factlink.Global.signed_in
      @shareFactSelectionRegion.show @_shareFactSelectionView()

  addComment: ->
    return if @submitting

    content = $.trim(@_textModel().get('text'))
    @model = new Comment
      content: content
      formatted_comment_content: content
      created_by: currentUser.toJSON()
      type: @options.argumentTypeModel.get 'argument_type'

    return @addModelError() unless @model.isValid()

    @disableSubmit()
    @addDefaultModel()
    @_shareFactlink(@model)

  setFormContent: (content) -> @_textModel().set 'text', content

  addModelSuccess: (model) ->
    @enableSubmit()
    @setFormContent ''

    mp_track "Factlink: Added comment",
      factlink_id: @options.addToCollection.fact.id
      type: @options.argumentTypeModel.get 'argument_type'

  _shareFactlink: (model) ->
    return unless Factlink.Global.can_haz.share_comment && Factlink.Global.signed_in

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
