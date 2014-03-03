window.ReactComment = React.createBackboneClass
  displayName: 'ReactComment'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(Comment).isRequired

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
      _span ["comment-post-bottom"],
        if @model().can_destroy()
          _span ["comment-post-delete"],
            ReactDeleteButton
              model: @model()
              onDelete: @_onDelete
        _span ["comment-reply"],
          _a ["spec-sub-comments-link", href:"javascript:", onClick: @_toggleSubcomments],
            "(#{sub_comment_count}) Comment"
      if @state.show_subcomments
        ReactSubComments
          model: @model().sub_comments()
          fact_opinionators: @props.fact_opinionators
    ]

  render: ->
    relevant = @model().argumentTally().relevance() >= 0

    _div ["comment-container", "spec-evidence-box", "comment-irrelevant" unless relevant],
      _div ["comment-votes-container"],
        ReactCommentVote model: @model().argumentTally()
      _div ["comment-content-container"],
        ReactCommentHeading
          fact_opinionators: @props.fact_opinionators
          model: @model()
        @_content()
        @_bottom()...

ReactCommentHeading = React.createBackboneClass
  displayName: 'ReactCommentHeading'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(Opinionators).isRequired
    model: React.PropTypes.instanceOf(Comment).isRequired

  render: ->
    creator = @model().creator()
    _div ['comment-post-heading'],
      ReactOpinionatedAvatar(
        user: creator
        model: @props.fact_opinionators
        size: 32
      ),
      _span ["comment-post-creator"],
          _a ["comment-post-creator-name", href: creator.link(), rel: "backbone"],
            creator.get('name')

        TimeAgo
          className: "comment-post-time"
          time: @model().get('created_at')

window.ReactOpinionatedAvatar = React.createBackboneClass
  displayName: "ReactOpinionatedAvatar"
  mixins: [UpdateOnFeaturesChangeMixin] # opinions_of_users_and_comments

  changeOptions: 'add remove reset sort' + ' change'

  propTypes:
    model: React.PropTypes.instanceOf(Opinionators).isRequired
    user: React.PropTypes.instanceOf(User).isRequired
    size:  React.PropTypes.number

  _user_opinion: -> @model().vote_for(@props.user.get('username'))?.get('type')

  _typeCss: ->
    if !Factlink.Global.can_haz.opinions_of_users_and_comments
      'comment-unsure'
    else
      switch @_user_opinion()
        when 'believes' then 'comment-believes'
        when 'disbelieves' then 'comment-disbelieves'
        else 'comment-unsure'

  render: ->
    _span ["opinionated-avatar", style: { height: @props.size + 'px' }],
      _span [@_typeCss()]
      _span ["post-creator-avatar", style: { width: @props.size + 'px'}],
        _img ["avatar-image", src: @props.user.avatar_url(@props.size)]


