ReactCommentVoteFactlink = React.createBackboneClass
  displayName: 'ReactCommentVoteFactlink'

  _on_up_vote: ->
    mp_track "Comment: Upvote click"
    @model().clickCurrentUserOpinion 'believes'

  _on_down_vote: ->
    mp_track "Comment: Downvote click"
    @model().clickCurrentUserOpinion 'disbelieves'

  render: ->
    _div ['comment-votes'],
      _a [
        'comment-vote-up'
        'comment-vote-active' if @model().get('current_user_opinion') == 'believes'
        'spec-comment-vote-up'
        href: "javascript:",
        onClick: => @refs.signinPopoverUp.submit(=> @_on_up_vote())
      ],
        _i ['icon-up-open']
        ReactSigninPopover
          ref: 'signinPopoverUp'

      _span ['comment-vote-amount spec-comment-vote-amount'],
        format_as_short_number(@model().relevance())

      _a [
        'comment-vote-down'
        'comment-vote-active' if @model().get('current_user_opinion') == 'disbelieves'
        'spec-comment-vote-down'
        href: "javascript:"
        onClick: => @refs.signinPopoverDown.submit(=> @_on_down_vote())
      ],
        _i ['icon-down-open']
        ReactSigninPopover
          ref: 'signinPopoverDown'


ReactCommentVoteKennisland = React.createBackboneClass
  displayName: 'ReactCommentVoteKennisland'

  _on_up_vote: ->
    mp_track "Comment: Upvote click"
    @model().clickCurrentUserOpinion 'believes'

  render: ->
    _div ['comment-votes'],
      _a [
        'comment-vote-up'
        'comment-vote-active' if @model().get('current_user_opinion') == 'believes'
        'spec-comment-vote-up'
        href: "javascript:",
        onClick: => @refs.signinPopoverUp.submit(=> @_on_up_vote())
      ],
        _i ['icon-up-open']
        ReactSigninPopover
          ref: 'signinPopoverUp'

      _span ['comment-vote-amount spec-comment-vote-amount'],
        format_as_short_number(@model().relevance())


if window.is_kennisland
  window.ReactCommentVote = ReactCommentVoteKennisland
else
  window.ReactCommentVote = ReactCommentVoteFactlink
