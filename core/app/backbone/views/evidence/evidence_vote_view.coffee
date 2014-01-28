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
    R.div className: 'evidence-vote',
      R.span className:"evidence-vote-relevance spec-evidence-relevance",
        format_as_short_number(@model().relevance())
      R.a
        className: "evidence-vote-up spec-evidence-vote-up"
        href: "javascript:" if Factlink.Global.signed_in
        onClick: @_on_up_vote
      R.a
        className: "evidence-vote-down spec-evidence-vote-down"
        href: "javascript:" if Factlink.Global.signed_in
        onClick: @_on_down_vote
