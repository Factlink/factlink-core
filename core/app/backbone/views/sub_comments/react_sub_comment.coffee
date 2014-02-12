window.ReactSubComment = React.createBackboneClass
  displayName: 'ReactSubComment'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(SubComment).isRequired

  _save: ->
    @model().saveWithState()

  _content_tag: ->
    if @model().get('formatted_content')
      _span ["subcomment-content spec-subcomment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_content')}]
    else
      _span ["subcomment-content spec-subcomment-content"],
        @model().get('content')

  render: ->
    _div ["sub-comment"],
      ReactSubCommentHeading
        fact_opinionators: @props.fact_opinionators
        model: @model()

      @_content_tag()

      if @model().get('save_failed') == true
        _a ['button-danger', onClick: @_save, style: {float: 'right'} ],
          'Save failed - Retry'
      if @model().can_destroy()
        window.ReactDeleteButton
          model: @model()
          onDelete: -> @model.destroy wait: true

ReactAvatar = React.createBackboneClass
  displayName: 'ReactAvatar'

  render: ->
    _a [href: @props.user.link()],
      _img [ "avatar-image",
        src: @props.user.avatar_url(@props.size)
      ]


ReactSubCommentHeading = React.createBackboneClass
  displayName: 'ReactSubCommentHeading'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(SubComment).isRequired

  render: ->
    creator = @model().creator()
    created_at = @model().get('created_at')
    _div ['sub-comment-post-heading'],
      OpinionIndicator
        username: creator.get('username')
        model: @props.fact_opinionators
      _span ["sub-comment-post-creator-avatar"],
        _img ["avatar-image", src: creator.avatar_url(28)] #has to be kept in sync with the css variable: @commentCreatorAvatarSize
      _span ["sub-comment-post-creator"],
        _a ["sub-comment-post-creator-name", href: creator.link(), rel: "backbone"],
          creator.get('name')
        if created_at
          TimeAgo
            className: "sub-comment-post-time"
            time: @model().get('created_at')
