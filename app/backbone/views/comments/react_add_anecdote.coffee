window.ReactAddAnecdote = React.createClass
  displayName: 'ReactAddAnecdote'

  render: ->
    ReactAnecdoteForm
      onSubmit: (text) =>
        comment = new Comment
          markup_format: 'anecdote'
          created_by: currentSession.user().toJSON()
          content: $.trim(text)

        @props.comments.unshift(comment)
        comment.saveWithFactAndWithState {},
          success: =>
            @props.comments.fact.getOpinionators().setInterested true


window.ReactAnecdoteForm = React.createClass
  displayName: 'ReactAnecdoteForm'

  renderField: (key, label) ->
    _div [],
      _strong [], label
      ReactTextArea
        ref: key
        defaultValue: JSON.parse(@props.defaultValue)[key] if @props.defaultValue
        storageKey: "add_anecdote_to_fact_#{key}_#{string_hash(@props.site_url)}" if @props.site_url
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

  _submit: ->
    @props.onSubmit? JSON.stringify
      introduction: @refs.introduction.getText()
      insight: @refs.insight.getText()
      resources: @refs.resources.getText()
      actions: @refs.actions.getText()
      effect: @refs.effect.getText()

    @refs.introduction.updateText ''
    @refs.insight.updateText ''
    @refs.resources.updateText ''
    @refs.actions.updateText ''
    @refs.effect.updateText ''
