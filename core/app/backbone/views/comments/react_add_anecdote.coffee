window.ReactAddAnecdote = React.createBackboneClass
  displayName: 'ReactAddAnecdote'

  renderField: (key, label) ->
    comment_add_uid = string_hash(@props.site_url)

    _div [],
      _strong [], label
      ReactTextArea
        ref: key
        storageKey: "add_anecdote_to_fact_#{key}_#{comment_add_uid}"
        onSubmit: => @refs.signinPopover.submit(=> @_submit())

  render: ->
    _div ['add-anecdote'],
      @renderField('introduction', 'Introduction')
      @renderField('insight', 'Sudden insight')
      @renderField('resources', 'Resources')
      @renderField('actions', 'Actions')
      @renderField('effect', 'Effect + evaluation')
      _button ['button-confirm button-small add-anecdote-post-button'
        onClick: => @refs.signinPopover.submit(=> @_submit())
      ],
        'Post ' + Factlink.Global.t.anecdote
        ReactSigninPopover
          ref: 'signinPopover'

  _content: ->
    JSON.stringify
      introduction: @refs.introduction.getText()
      insight: @refs.insight.getText()
      resources: @refs.resources.getText()
      actions: @refs.actions.getText()
      effect: @refs.effect.getText()

  _submit: ->
    comment = new Comment
      content: @_content()
      markup_format: 'anecdote'
      created_by: currentSession.user().toJSON()

    return unless comment.isValid()

    @model().unshift(comment)
    comment.saveWithFactAndWithState()
