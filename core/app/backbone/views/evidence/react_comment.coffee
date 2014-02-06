ReactCommentHeading = React.createBackboneClass
  displayName: 'ReactCommentHeading'

  _typeCss: ->
    return 'comment-unsure' unless Factlink.Global.can_haz.opinions_of_users_and_comments

    switch @model().get('type')
      when 'believes' then 'comment-believes'
      when 'disbelieves' then 'comment-disbelieves'
      else 'comment-unsure'

  render: ->
    _div ['comment-post-heading'],
      _span [@_typeCss()]
      _span ["comment-post-creator-avatar"],
        _img ["avatar-image", src: @model().creator().avatar_url(32)]
      _span ["comment-post-creator"],
        _a ["comment-post-creator-name", href: @model().creator().link(), rel: "backbone"],
          @model().creator().get('name')
        TimeAgo
          className: "comment-post-time"
          time: @model().get('created_at')

window.ReactComment = React.createBackboneClass
  displayName: 'ReactComment'

  getInitialState: ->
    show_subcomments: false

  _onDelete: ->
     @model().destroy wait: true

  _toggleSubcomments: ->
    @setState show_subcomments: !@state.show_subcomments

  _content: ->

    _div ["comment-content spec-comment-content",
      dangerouslySetInnerHTML: {__html: @model().get('formatted_content')}]

  _bottom: ->
    sub_comment_count = @model().get('sub_comments_count')

    [
      _ul ["comment-post-bottom"], [
        if @model().can_destroy()
          _li ["comment-post-delete"],
            ReactDeleteButton
              model: @model()
              onDelete: @_onDelete
        _li ["comment-reply"],
          _a ["spec-sub-comments-link", href:"javascript:", onClick: @_toggleSubcomments],
            "(#{sub_comment_count}) Comment"
      ]
      if @state.show_subcomments
        ReactSubComments(model: @model())
    ]

  render: ->
    relevant = @model().argumentTally().relevance() >= 0

    top_classes = [
      'comment-region'
      'comment-irrelevant' unless relevant
    ].join(' ')

    _div [top_classes],
      _div ["comment-container spec-evidence-box"],
        _div ["comment-votes-container"],
          ReactEvidenceVote model: @model().argumentTally()
        _div ["comment-content-container"],
          ReactCommentHeading(model: @model())
          @_content()
          @_bottom()
