

window.ReactComment = React.createBackboneClass
  displayName: 'ReactComment'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(InterestedUsers).isRequired
    model: React.PropTypes.instanceOf(Comment).isRequired

  getInitialState: ->
    show_subcomments: false

  _onDelete: ->
     @model().destroy wait: true

  _toggleSubcomments: ->
    @setState show_subcomments: !@state.show_subcomments

  _content: ->
    if @model().get('formatted_content')
      _div ["comment-content spec-comment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_content')}]
    else
      _div ["comment-content spec-comment-content"],
        @model().get('content')

  _separator: ->
    nbsp = "\u00a0"
    middle_dot = "\u00b7"

    "#{nbsp}#{nbsp}#{middle_dot}#{nbsp}#{nbsp}"

  _bottom: ->
    sub_comment_count = @model().get('sub_comments_count')

    _span [],
      _span ["comment-post-bottom"],
        if @model().can_destroy()
          _span ["comment-post-bottom-right"],
            ReactSlidingDeleteButton
              model: @model()
              onDelete: @_onDelete
        _a ["spec-sub-comments-link", href:"javascript:", onClick: @_toggleSubcomments],
          "(#{sub_comment_count}) Reply"
        @_separator()
        ReactSlidingShareButton
          model: @model()
      if @state.show_subcomments
        ReactSubComments
          model: @model().sub_comments()
          fact_opinionators: @props.fact_opinionators

  _save: ->
    @model().saveWithState()

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

        if @model().get('save_failed') == true
          ReactRetryButton onClick: @_save

      _div ["comment-subcontent-container"],
        if not @model().isNew()
          @_bottom()

ReactCommentHeading = React.createBackboneClass
  displayName: 'ReactCommentHeading'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(InterestedUsers).isRequired
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
    model: React.PropTypes.instanceOf(InterestedUsers).isRequired
    user: React.PropTypes.instanceOf(User).isRequired
    size:  React.PropTypes.number

  render: ->
    _span ["opinionated-avatar", style: { height: @props.size + 'px' }],
      _span ["post-creator-avatar", style: { width: @props.size + 'px'}],
        _img ["avatar-image", src: @props.user.avatar_url(@props.size)]


