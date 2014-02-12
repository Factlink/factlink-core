ReactSubCommentsAdd = React.createClass
  displayName: 'ReactSubCommentsAdd'

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
    _div ['sub-comment-add', 'spec-sub-comments-form'],
      ReactTextArea
        placeholder: 'Leave a reply'
        onChange: @updateText
        defaultValue: ''
        ref: 'text_area'
        onSubmit: @submit
      _button ["button-confirm button-small spec-submit",
               disabled: !@is_valid(),
               onClick: @submit],
        Factlink.Global.t.post_subcomment

window.ReactSubComments = React.createBackboneClass
  displayName: 'ReactSubComments'
  changeOptions: 'add remove reset sort' + ' sync request'

  componentWillMount: ->
    @model().fetch()

  render: ->
    if @model().size() == 0 && @model().loading()
      ReactLoadingIndicator()
    else
      _div [],
        @model().map (sub_comment) =>
          ReactSubComment(model: sub_comment)
        if Factlink.Global.signed_in
          ReactSubCommentsAdd(addToCollection: @model())
