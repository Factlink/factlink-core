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

  initialize: ->
    @_textModel = new Backbone.Model text: ''

    @_textAreaComponent = Backbone.Factlink.ReactTextArea
      model: @_textModel
      placeholder: 'Comment...'
    @_textAreaView = new ReactView
        component: @_textAreaComponent

  onRender: ->
    @textareaRegion.show @_textAreaView

  submit: ->
    return if @submitting

    @model = new SubComment
      content: $.trim(@_textModel.get('text'))
      created_by: currentUser.toJSON()

    return @addModelError() unless @model.isValid()

    @disableSubmit()
    @addDefaultModel()

  addModelSuccess: ->
    @enableSubmit()
    @_textModel.set 'text', ''
    @_textAreaComponent.forceUpdate()

  addModelError: ->
    @enableSubmit()
    FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'


  enableSubmit: ->
    @submitting = false
    @ui.submit.prop('disabled',false).text(Factlink.Global.t.post_subcomment)

  disableSubmit: ->
    @submitting = true
    @ui.submit.prop('disabled',true ).text('Posting...')

class window.SubCommentContainerView extends Backbone.Marionette.Layout
  className: 'sub-comment-container'
  template: 'sub_comments/sub_comment_container'

  regions:
    headingRegion: '.js-heading-region'
    innerRegion: '.js-inner-region'

  onRender: ->
    @headingRegion.show new EvidenceishHeadingView model: @options.creator
    @innerRegion.show @options.innerView


class window.SubCommentsView extends Backbone.Marionette.CollectionView
  className: 'sub-comments'
  emptyView: Backbone.Factlink.EmptyLoadingView
  itemView: SubCommentContainerView

  itemViewOptions: (model) ->
    if model instanceof SubComment
      creator: model.creator()
      innerView: new ReactView
        component: ReactSubComment(model: model)
    else # emptyView
      collection: @collection

  _initialEvents: ->
    @listenTo @collection, "add remove sync", @render

  initialize: ->
    @collection.fetch()

    if Factlink.Global.signed_in
      @_addViewContainer = new SubCommentsAddView addToCollection: @collection

  onRender: ->
    return if @collection.loading()

    @closeEmptyView() if @collection.length <= 0

    # Cannot use region as the AddView needs to be sibling in the DOM tree of the other SubCommentContainerViews
    if Factlink.Global.signed_in
      @_renderAddViewContainer()
      @$el.append @_addViewContainer.el

  _renderAddViewContainer: ->
    return if @_addViewContainerRendered

    @_addViewContainer.render()
    @_addViewContainerRendered = true

  onClose: ->
    if Factlink.Global.signed_in
      @_addViewContainer.close()
