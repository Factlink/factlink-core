class window.EvidenceVoteView extends Backbone.Marionette.ItemView
  className: 'evidence-vote'
  template: 'evidence/evidence_vote'

  events:
    "click .js-up":   "_on_up_vote"
    "click .js-down": "_on_down_vote"

  ui:
    upButton: '.js-up'
    downButton: '.js-down'
    relevance: '.js-relevance'

  modelEvents:
    'change': '_updateValues'

  onRender: ->
    @_updateValues()

  _updateValues: ->
    @ui.relevance.text format_as_short_number(@model.relevance())

  _on_up_vote: ->
    return unless Factlink.Global.signed_in

    mp_track "Factlink: Upvote evidence click"
    @model.clickCurrentUserOpinion 'believes'

  _on_down_vote: ->
    return unless Factlink.Global.signed_in

    mp_track "Factlink: Downvote evidence click"
    @model.clickCurrentUserOpinion 'disbelieves'
