ReactSubCommentsAdd = React.createClass
  getInitialState: ->
    text: ''
    phase: 'new'

  updateText: (e)->
    @setState text: e.target.value

  submit: ->
    return if @state.phase == 'submitting'
    @state.phase = 'submitting'

    model = new SubComment
      content: $.trim(@state.text)
      created_by: currentUser.toJSON()

    if model.isValid()
      @props.addToCollection.add(model)
      model.save {},
        success: =>
          @setState phase: 'new'
          @setState text: ''
        error: =>
          @props.addToCollection.remove(model)
          @setState phase: 'new'
          FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'
    else
      @setState phase: 'new'
      FactlinkApp.NotificationCenter.error 'Your comment is not valid.'

  render: ->
    submit_button =
      if @state.phase == 'new'
        R.button className: "js-submit button button-confirm button-small post-comment-button", onClick: @submit,
          Factlink.Global.t.post_subcomment
      else
        R.button className: "js-submit button button-confirm button-small post-comment-button", onClick: @submit, disabled: true,
          'Posting...'

    R.div className: 'discussion-evidenceish-content sub-comments-add spec-sub-comments-form',
      R.textarea
        className: "text_area_view",
        placeholder: 'Comment...'
        onChange: @updateText
        ref: 'textarea'
        value: @state.text
      submit_button

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
      @_addViewContainer = new ReactView
        component: new ReactSubCommentsAdd
          addToCollection: @collection

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
