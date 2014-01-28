window.ReactEvidenceVote = React.createBackboneClass
  _on_up_vote: ->
    return unless Factlink.Global.signed_in

    mp_track "Factlink: Upvote evidence click"
    @model().clickCurrentUserOpinion 'believes'

  _on_down_vote: ->
    return unless Factlink.Global.signed_in

    mp_track "Factlink: Downvote evidence click"
    @model().clickCurrentUserOpinion 'disbelieves'

  render: ->
    up_classes = [
      'evidence-vote-up'
      'evidence-active' if @model().get('current_user_opinion') == 'believes'
      'spec-evidence-vote-up'
    ].join(' ')

    down_classes = [
      'evidence-vote-down'
      'evidence-active' if @model().get('current_user_opinion') == 'disbelieves'
      'spec-evidence-vote-down'
    ].join(' ')

    R.div className: 'evidence-vote',
      R.span className:"evidence-vote-relevance spec-evidence-relevance",
        format_as_short_number(@model().relevance())
      R.a
        className: up_classes
        href: "javascript:" if Factlink.Global.signed_in
        onClick: @_on_up_vote
      R.a
        className: down_classes
        href: "javascript:" if Factlink.Global.signed_in
        onClick: @_on_down_vote
