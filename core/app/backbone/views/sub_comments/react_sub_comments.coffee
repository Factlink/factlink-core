React.defineClass('ReactSubCommentsAdd')
  getInitialState: ->
    text: ''

  model_for_text: ->
    model = new SubComment
      content: @state.text
      created_by: currentUser.toJSON()

  submit: ->
    model = @model_for_text()
    @props.addToCollection.add(model)
    model.saveWithState()
    @refs.text_area.updateText ''

  updateText: (text)->
    @setState text: $.trim(text)

  is_valid: ->
    @model_for_text().isValid()

  render: ->
    R.div className: 'sub-comment-add spec-sub-comments-form',
      ReactTextArea
        placeholder: 'Leave a reply'
        onChange: @updateText
        defaultValue: ''
        ref: 'text_area'
        onSubmit: @submit
      _button ["button button-confirm button-small spec-submit",
               disabled: !@is_valid(),
               onClick: @submit],
        Factlink.Global.t.post_subcomment

window.ReactSubCommentList = React.createBackboneClass
  componentDidMount: ->
    @props.model.on 'sync request', (-> @forceUpdate()), @

  componentWillMount: ->
    @model().fetch()

  render: ->
    if @model().size() == 0 && @model().loading()
      ReactLoadingIndicator()
    else
      R.div {},
        @model().map (sub_comment) =>
          ReactSubComment(model: sub_comment)
        if Factlink.Global.signed_in
          ReactSubCommentsAdd(addToCollection: @model())

window.ReactSubComments = React.createClass
  render: ->
    ReactSubCommentList model: @props.model.sub_comments()
