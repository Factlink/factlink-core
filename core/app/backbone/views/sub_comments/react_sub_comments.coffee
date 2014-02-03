ReactSubCommentsAdd = React.createClass
  getInitialState: ->
    phase: 'new'

  submit: ->
    return if @state.phase == 'submitting'
    @setState phase: 'submitting'

    model = new SubComment
      content: $.trim(@refs.text_area.state.text)
      created_by: currentUser.toJSON()

    if model.isValid()
      @props.addToCollection.add(model)
      model.save {},
        success: =>
          @setState phase: 'new'
          @refs.text_area.updateText ''
        error: =>
          @props.addToCollection.remove(model)
          @setState phase: 'new'
          FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'
    else
      @setState phase: 'new'
      FactlinkApp.NotificationCenter.error 'Your comment is not valid.'

  render: ->
    submit_button_classes = "button button-confirm button-small spec-submit"
    submit_button =
      if @state.phase == 'new'
        R.button className: submit_button_classes, onClick: @submit,
          Factlink.Global.t.post_subcomment
      else
        R.button className: submit_button_classes, disabled: true,
          'Posting...'

    R.div className: 'sub-comment-add spec-sub-comments-form',
      ReactTextArea
        placeholder: 'Leave a reply'
        onChange: @updateText
        defaultValue: ''
        ref: 'text_area'
        onSubmit: @submit
      submit_button


window.ReactLoadingIndicator = React.createClass
  render: ->
    R.img
      className: 'ajax-loader'
      src: Factlink.Global.ajax_loader_image

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
