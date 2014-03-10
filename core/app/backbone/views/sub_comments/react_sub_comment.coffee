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
        ReactRetryButton onClick: @_save

      if @model().can_destroy()
        window.ReactDeleteButton
          model: @model()
          onDelete: -> @model.destroy wait: true


ReactSubCommentHeading = React.createBackboneClass
  displayName: 'ReactSubCommentHeading'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(SubComment).isRequired

  render: ->
    creator = @model().creator()
    created_at = @model().get('created_at')
    _div ['sub-comment-post-heading'],
      ReactOpinionatedAvatar
        user: creator
        model: @props.fact_opinionators
        size: 28
      _span ["sub-comment-post-creator"],
        _a ["sub-comment-post-creator-name", href: creator.link(), rel: "backbone"],
          creator.get('name')
        if created_at
          TimeAgo
            className: "sub-comment-post-time"
            time: @model().get('created_at')
