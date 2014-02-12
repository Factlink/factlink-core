ReactSubCommentsAdd = React.createBackboneClass
  displayName: 'ReactSubCommentsAdd'

  getInitialState: ->
    text: sessionStorage?["add_subcomment_to_comment_#{@model().parentModel.id}"] || ''
    opened: false

  _changeText: (text, opened) ->
    @setState text: text, opened: opened
    if sessionStorage?
      sessionStorage["add_subcomment_to_comment_#{@model().parentModel.id}"] = text

  _subComment: ->
    new SubComment
      content: $.trim(@state.text)
      created_by: currentUser.toJSON()

  _submit: ->
    sub_comment = @_subComment()
    return unless sub_comment.isValid()

    @model().add(sub_comment)
    sub_comment.saveWithState()
    @_changeText '', false

  is_valid: ->
    @_subComment().isValid()

  render: ->
    R.div className: 'sub-comment-add spec-sub-comments-form',
      ReactTextArea
        placeholder: 'Leave a reply'
        onChange: (text) => @_changeText text, true
        value: @state.text
        ref: 'text_area'
        onSubmit: @_submit
      if @state.opened
        _button ["button-confirm button-small spec-submit",
          onClick: @_submit
          disabled: !@_subComment().isValid()
        ],
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
          ReactSubComment model: sub_comment
        if Factlink.Global.signed_in
          ReactSubCommentsAdd model: @model()

window.ReactSubComments = React.createClass
  displayName: 'ReactSubComments'

  render: ->
    ReactSubCommentList model: @props.model.sub_comments()
