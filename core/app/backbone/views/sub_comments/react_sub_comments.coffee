window.ReactSubComments = React.createBackboneClass
  displayName: 'ReactSubComments'
  changeOptions: 'add remove reset sort' + ' sync request'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(SubComments).isRequired

  componentWillMount: ->
    @model().fetch()

  render: ->
    if @model().size() == 0 && @model().loading()
      ReactLoadingIndicator()
    else
      _div [],
        @model().map (sub_comment) =>
          ReactSubComment
            model: sub_comment
            key: sub_comment.get('id')
            fact_opinionators: @props.fact_opinionators
        if Factlink.Global.signed_in
          ReactSubCommentsAdd model: @model()


ReactSubCommentsAdd = React.createBackboneClass
  displayName: 'ReactSubCommentsAdd'

  getInitialState: ->
    text: ''
    opened: false

  _subComment: ->
    new SubComment
      content: $.trim(@state.text)
      created_by: currentUser.toJSON()

  _submit: ->
    sub_comment = @_subComment()
    return unless sub_comment.isValid()

    @model().add(sub_comment)
    sub_comment.saveWithState()

    @refs.textarea.updateText ''
    @setState opened: false

  _onTextareaChange: (text) ->
    @setState(text: text)
    @setState(opened: true) if text.length > 0

  render: ->
    x="as"
    _div ['sub-comment-add', 'spec-sub-comments-form'],
      ReactTextArea
        ref: 'textarea'
        placeholder: 'Leave a reply'
        storageKey: "add_subcomment_to_comment_#{@model().parentModel.id}"
        onChange: @_onTextareaChange
        onSubmit: @_submit
      if @state.opened
        _button ["button-confirm button-small spec-submit",
          disabled: !@_subComment().isValid()
          onClick: @_submit
        ],
          Factlink.Global.t.post_subcomment

