ReactCommentHeading = React.createBackboneClass
  render: ->
    R.div className: 'discussion-evidenceish-heading',
      R.span className:"heading-avatar",
        R.img
          src: @model().avatar_url(32)
          className:"heading-avatar-image"
      R.a
        href: @model().link()
        className:"discussion-evidenceish-name popover-link js-user-link"
        rel: "backbone"
        @model().get('name')

ReactCommentReply = React.createBackboneClass
  render: ->
    count = @model().get('sub_comments_count')
    R.span {},
      "(#{count}) Reply"

window.ReactComment = React.createBackboneClass
  getInitialState: ->
    show_subcomments: false

  _typeCss: ->
    switch @model().get('type')
      when 'believes' then 'evidence-believes'
      when 'disbelieves' then 'evidence-disbelieves'
      when 'doubts' then 'evidence-unsure'

  _onDelete: ->
     @model().destroy wait: true

  _toggleSubcomments: ->
    @setState show_subcomments: !@state.show_subcomments

  render: ->
    relevant = @model().argumentTally().relevance() >= 0

    top_classes = [
      'evidence-argument'
      @_typeCss()
      'evidence-irrelevant' unless relevant
    ].join(' ')

    R.div className: top_classes,
      R.div className:"discussion-evidenceish-box spec-evidence-box",
        R.div className: "js-heading-region",
          ReactCommentHeading(model: @model().creator())
        R.div
          className:"discussion-evidenceish-content discussion-evidenceish-text",
          dangerouslySetInnerHTML: {__html: @model().get('formatted_comment_content')}
        R.div className: 'comment-bottom',
          R.ul className: "comment-bottom-actions", [
            R.li className: "comment-bottom-action js-vote-region",
              ReactEvidenceVote model: @model().argumentTally()
            R.li className:"comment-bottom-action comment-bottom-action-time",
              R.i className:"icon-time"
              @model().get('time_ago')
              " "
              Factlink.Global.t.ago
            if @model().can_destroy()
              R.li className: "comment-bottom-action comment-bottom-action-delete js-delete-region",
                ReactDeleteButton
                  model: @model()
                  onDelete: @_onDelete
            R.li className:"js-sub-comments-link-container comment-bottom-action",
              R.a
                className:"js-sub-comments-link js-sub-comments-link-region"
                href:"javascript:"
                onClick: @_toggleSubcomments

                ReactCommentReply model: @model()
          ]
      if @state.show_subcomments
        R.div className: "js-sub-comments-region",
          ReactSubComments
            model: new SubComments([], parentModel: @model())
