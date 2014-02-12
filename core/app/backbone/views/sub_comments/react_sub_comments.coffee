ReactSubCommentsAdd = React.createClass
  displayName: 'ReactSubCommentsAdd'

  getInitialState: ->
    text: ''

  _subComment: ->
    new SubComment
      content: $.trim(@state.text)
      created_by: currentUser.toJSON()

  _submit: ->
    sub_comment = @_subComment()
    return unless sub_comment.isValid()

    @props.addToCollection.add(sub_comment)
    sub_comment.saveWithState()
    @setState text: ''

  is_valid: ->
    @_subComment().isValid()

  render: ->
    R.div className: 'sub-comment-add spec-sub-comments-form',
      ReactTextArea
        placeholder: 'Leave a reply'
        onChange: (text) => @setState text: text
        value: @state.text
        ref: 'text_area'
        onSubmit: @_submit
      if @_subComment().isValid()
        _button ["button-confirm button-small spec-submit", onClick: @_submit],
          Factlink.Global.t.post_subcomment

window.ReactSubCommentList = React.createBackboneClass
  displayName: 'ReactSubCommentList'
  changeOptions: 'add remove reset sort' + ' sync request'

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
  displayName: 'ReactSubComments'

  render: ->
    ReactSubCommentList model: @props.model.sub_comments()
