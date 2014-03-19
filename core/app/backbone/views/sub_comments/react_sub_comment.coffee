window.ReactSubComment = React.createBackboneClass
  displayName: 'ReactSubComment'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(SubComment).isRequired

  _save: ->
    @model().saveWithState()

  _content_tag: ->
    if @model().get('formatted_content')
      _span ["sub-comment-content spec-subcomment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_content')}]
    else
      _span ["sub-comment-content spec-subcomment-content"],
        @model().get('content')

  render: ->
    creator = @model().creator()
    created_at = @model().get('created_at')

    _div ["sub-comment"],
      _div ['sub-comment-avatar-container'],
        ReactOpinionatedAvatar
          user: creator
          model: @props.fact_opinionators
          size: 30

      _div ['sub-comment-content-container'],
        _a [" sub-comment-creator", href: creator.link(), rel: "backbone"],
          creator.get('name')
        if created_at
          TimeAgo
            className: "sub-comment-post-time"
            time: @model().get('created_at')

        @_content_tag()

        if @model().get('save_failed') == true
          ReactRetryButton onClick: @_save

        if @model().can_destroy()
          _div ["sub-comment-post-delete"],
            window.ReactDeleteButton
              model: @model()
              onDelete: -> @model.destroy wait: true
