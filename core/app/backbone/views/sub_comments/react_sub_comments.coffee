React.defineClass('ReactSubCommentsAdd')
  getInitialState: ->
    text: ''

  submit: ->
    model = new SubComment
      content: @state.text
      created_by: currentUser.toJSON()

    unless model.isValid()
      FactlinkApp.NotificationCenter.error "Your comment '#{model.get('content')}' is not valid."
      return

    @props.addToCollection.add(model)
    model.save {},
      success: =>
      error: =>
        @props.addToCollection.remove(model)
        FactlinkApp.NotificationCenter.error "Your comment '#{model.get('content')}' could not be posted, please try again."
    @refs.text_area.updateText ''

  updateText: (text)->
    @state.text = $.trim(text)

  render: ->
    R.div className: 'sub-comment-add spec-sub-comments-form',
      ReactTextArea
        placeholder: 'Leave a reply'
        onChange: @updateText
        defaultValue: ''
        ref: 'text_area'
        onSubmit: @submit
      _button ["button button-confirm button-small spec-submit", onClick: @submit],
        Factlink.Global.t.post_subcomment

window.ReactSubCommentList = React.createBackboneClass
  getInitialState: ->
    loading: true

  componentDidMount: ->
    @model().fetch
      success: => @setState loading: false
    @setState loading: true

  render: ->
    if @model().size() == 0 && @state.loading
      ReactLoadingIndicator()
    else
      R.div className: 'sub-comments',
        @model().map (sub_comment) =>
          ReactSubComment(model: sub_comment)
        if Factlink.Global.signed_in
          ReactSubCommentsAdd(addToCollection: @model())

window.ReactSubComments = React.createClass
  render: ->
    ReactSubCommentList model: @props.model.sub_comments()
