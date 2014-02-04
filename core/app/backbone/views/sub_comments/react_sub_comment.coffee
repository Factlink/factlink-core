React.defineBackboneClass('ReactAvatar')
  render: ->
    _a [href: @props.user.link()],
      _img [ "avatar-image",
          src: @props.user.avatar_url(@props.size)
        ]

React.defineBackboneClass('ReactSubComment')
  _save: ->
    @model().set save_failed: false
    @model().save {},
      error: =>
        @model().set save_failed: true

  _content_tag: ->
    if @model().get('formatted_comment_content')
      _span ["subcomment-content spec-subcomment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_comment_content')}]
    else
      _span ["subcomment-content spec-subcomment-content"],
        @model().get('content')

  render: ->
    creator = @model().creator()
    R.div className: "sub-comment",
      R.span className: "sub-comment-avatar",
        ReactAvatar user: creator, size: 28
      R.div "",
        R.a className: "sub-comment-creator", href: creator.link(),
          creator.get("name")

        if @model().get('time_ago')
          R.span className: "sub-comment-time",
            @model().get('time_ago'),
            ' '
            Factlink.Global.t.ago


      @_content_tag()

      if @model().get('save_failed') == true
        _a ['button', 'button-danger', onClick: @_save, style: {float: 'right'} ],
          'Save failed - Retry'
      else if @model().can_destroy()
        window.ReactDeleteButton
          model: @model()
          onDelete: -> @model.destroy wait: true
