class window.NDPEvidenceVoteView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'evidence-impact-vote'

  template: 'evidence/ndp_evidence_vote'

  events:
    "click .js-up": "_on_up_vote"
    "click .js-down":  "_on_down_vote"

  initialize: ->
    @bindTo @model, "change", @render, @

  onRender: ->
    @$('a.js-up').addClass('active')    if @model.get('current_user_opinion') == 'believes'
    @$('a.js-down').addClass('active')  if @model.get('current_user_opinion') == 'disbelieves'

  _on_up_vote: ->
    mp_track "Factlink: Upvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @open_vote_popup '.js-up', FactRelationVoteUpView
    else
      if @model.isBelieving()
        @model.removeOpinion()
      else
        @model.believe()

  _on_down_vote: ->
    mp_track "Factlink: Downvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @open_vote_popup '.js-down',  FactRelationVoteDownView
    else
      if @model.isDisBelieving()
        @model.removeOpinion()
      else
        @model.disbelieve()

  open_vote_popup: (selector, view_klass) ->
    return if @popoverOpened selector

    @popoverResetAll()
    @popoverAdd selector,
      side: @side()
      align: 'top'
      fadeTime: 40
      contentView: @bound_popup_view view_klass

  bound_popup_view: (view_klass) ->
    view = new view_klass model: @model

    @bindTo view, 'saved', =>
      @popoverResetAll()

    view

  side: ->
    if @model.get('type') == 'believes'
      'left'
    else
      'right'
