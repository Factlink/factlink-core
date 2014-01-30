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
      'comment-vote-up'
      'evidence-active' if @model().get('current_user_opinion') == 'believes'
      'spec-evidence-vote-up'
    ].join(' ')

    down_classes = [
      'comment-vote-down'
      'evidence-active' if @model().get('current_user_opinion') == 'disbelieves'
      'spec-evidence-vote-down'
    ].join(' ')

    if Factlink.Global.signed_in
      R.div className: 'comment-votes',
    else
      R.div className: 'comment-votes disabled',

        if Factlink.Global.signed_in
          R.a
            className: up_classes
            href: "javascript:"
            onClick: @_on_up_vote
            R.i className: "icon-up-open"
        else
          R.span
            className: up_classes
            R.i className: "icon-up-open"

        R.span className:"comment-vote-amount spec-evidence-relevance",
          format_as_short_number(@model().relevance())

        if Factlink.Global.signed_in
          R.a
            className: down_classes
            href: "javascript:"
            onClick: @_on_down_vote
            R.i className: "icon-down-open"
        else
          R.span
            className: down_classes
            R.i className: "icon-down-open"
