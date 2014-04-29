window.ReactAddAnecdote = React.createClass
  displayName: 'ReactAddAnecdote'

  renderField: (key, label) ->
    comment_add_uid = string_hash(@props.site_url)

    _div [],
      _strong [], label
      ReactTextArea
        ref: key
        defaultValue: JSON.parse(@props.model.get('content'))[key] if @props.model
        storageKey: "add_anecdote_to_fact_#{key}_#{comment_add_uid}" unless @props.model
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
    if @props.model
      @props.model.set 'content', @_content()
      @props.model.saveWithState()
    else
      comment = new Comment
        markup_format: 'anecdote'
        created_by: currentSession.user().toJSON()
        content: @_content()
      @props.comments.unshift(comment)
      comment.saveWithFactAndWithState {},
        success: =>
          @props.comments.fact.getOpinionators().setInterested true

    @props.onSubmit?()
