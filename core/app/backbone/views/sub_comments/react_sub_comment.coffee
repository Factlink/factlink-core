window.ReactAvatar = React.createBackboneClass
  render: ->
    R.a href: @props.user.link(),
      R.img src: @props.user.avatar_url(@props.size)

window.ReactSubComment = React.createBackboneClass
  render: ->
    creator = @model().creator()

    R.div className: "sub-comment",
      R.span className: "sub-comment-avatar",
        ReactAvatar user: creator, size: 28
      R.span
        className: "subcomment-content spec-subcomment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_comment_content')}
      ' — '
      R.a className: "sub-comment-creator", href: creator.link(),
        creator.get("name")
      ' '
      R.span className: "sub-comment-time",
        @model().get('time_ago'),
        ' '
        Factlink.Global.t.ago

      if @model().can_destroy()
        window.ReactDeleteButton
          model: @model()
          onDelete: -> @model.destroy wait: true
