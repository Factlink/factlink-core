React.defineBackboneClass('ReactAvatar')
  render: ->
    _a [href: @props.user.link()],
      _img [ "avatar-image",
          src: @props.user.avatar_url(@props.size)
        ]

React.defineBackboneClass('ReactSubComment')
  render: ->
    creator = @model().creator()

    R.div className: "sub-comment",
      R.span className: "sub-comment-avatar",
        ReactAvatar user: creator, size: 28
      R.div className: "sub-comment-heading",
        R.a className: "sub-comment-creator", href: creator.link(),
          creator.get("name")

        R.span className: "sub-comment-time",
          @model().get('time_ago'),
          ' '
          Factlink.Global.t.ago

      R.span
        className: "subcomment-content spec-subcomment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_comment_content')}

      if @model().can_destroy()
        window.ReactDeleteButton
          model: @model()
          onDelete: -> @model.destroy wait: true
