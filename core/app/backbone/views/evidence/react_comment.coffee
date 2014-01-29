ReactCommentHeading = React.createBackboneClass
  render: ->
    R.div className: 'comment-post-heading',
      R.span className:"heading-avatar",
        R.img
          src: @model().creator().avatar_url(32)
          className:"heading-avatar-image"
      R.a
        href: @model().creator().link()
        className:"comment-creator-name popover-link"
        rel: "backbone"
        @model().creator().get('name')
      R.span className:"comment-bottom-action comment-post-time",
          R.i className:"icon-time"
          @model().get('time_ago')
          " "
          Factlink.Global.t.ago

window.ReactComment = React.createBackboneClass
  getInitialState: ->
    show_subcomments: false

  _typeCss: ->
    switch @model().get('type')
      when 'believes' then 'comment-believes'
      when 'disbelieves' then 'comment-disbelieves'
      when 'doubts' then 'comment-unsure'

  _onDelete: ->
     @model().destroy wait: true

  _toggleSubcomments: ->
    @setState show_subcomments: !@state.show_subcomments

  _content: ->
    R.div
      className:"comment-post-content discussion-evidenceish-text",
      dangerouslySetInnerHTML: {__html: @model().get('formatted_comment_content')}

  _bottom: ->
    sub_comment_count = @model().get('sub_comments_count')

    R.div className: 'comment-bottom',
      R.ul className: "comment-bottom-actions", [
        R.li className: "comment-bottom-action",
          ReactEvidenceVote model: @model().argumentTally()

        if @model().can_destroy()
          R.li className: "comment-bottom-action comment-bottom-action-delete",
            ReactDeleteButton
              model: @model()
              onDelete: @_onDelete
        R.li className:"comment-bottom-action",
          R.a
            className:"spec-sub-comments-link"
            href:"javascript:"
            onClick: @_toggleSubcomments

            "(#{sub_comment_count}) Reply"
      ]
  render: ->
    relevant = @model().argumentTally().relevance() >= 0

    top_classes = [
      'evidence-argument'
      @_typeCss()
      'evidence-irrelevant' unless relevant
    ].join(' ')

    R.div className: top_classes,
      R.div className:"comment-container spec-evidence-box",
        ReactCommentHeading(model: @model())
        @_content()
        @_bottom()
      if @state.show_subcomments
        ReactSubComments(model: @model())
