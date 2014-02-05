ReactCommentHeading = React.createBackboneClass
  displayName: 'ReactCommentHeading'

  _typeCss: ->
    return 'comment-unsure' unless Factlink.Global.can_haz.opinions_of_users_and_comments

    switch @model().get('type')
      when 'believes' then 'comment-believes'
      when 'disbelieves' then 'comment-disbelieves'
      when 'doubts' then 'comment-unsure'

  render: ->
    R.div className: 'comment-post-heading',
      R.span className: @_typeCss()
      R.span className:"comment-post-creator-avatar",
        R.img
          src: @model().creator().avatar_url(32)
          className:"avatar-image"
      R.span className:"comment-post-creator",
        R.a
          href: @model().creator().link()
          className:"comment-post-creator-name"
          rel: "backbone"
          @model().creator().get('name')
        R.span className:"comment-bottom-action comment-post-time",
            @model().get('time_ago')
            " "
            Factlink.Global.t.ago

window.ReactComment = React.createBackboneClass
  displayName: 'ReactComment'

  getInitialState: ->
    show_subcomments: false


  _onDelete: ->
     @model().destroy wait: true

  _toggleSubcomments: ->
    @setState show_subcomments: !@state.show_subcomments

  _content: ->
    R.div
      className:"comment-content spec-comment-content",
      dangerouslySetInnerHTML: {__html: @model().get('formatted_comment_content')}

  _bottom: ->
    sub_comment_count = @model().get('sub_comments_count')

    R.div className: 'comment-post-bottom',
      R.ul className: "comment-bottom-actions", [
        if @model().can_destroy()
          R.li className: "comment-bottom-action comment-bottom-action-delete",
            ReactDeleteButton
              model: @model()
              onDelete: @_onDelete
        R.li className:"comment-reply",
          R.a
            className:"spec-sub-comments-link"
            href:"javascript:"
            onClick: @_toggleSubcomments

            "(#{sub_comment_count}) Comment"
      ]
      if @state.show_subcomments
        ReactSubComments(model: @model())

  render: ->
    relevant = @model().argumentTally().relevance() >= 0

    top_classes = [
      'comment-region'
      'comment-irrelevant' unless relevant
    ].join(' ')

    R.div className: top_classes,
      R.div className:"comment-container spec-evidence-box",
        R.div className: "comment-votes-container",
          ReactEvidenceVote model: @model().argumentTally()
        R.div className: "comment-content-container",
          ReactCommentHeading(model: @model())
          @_content()
          @_bottom()
