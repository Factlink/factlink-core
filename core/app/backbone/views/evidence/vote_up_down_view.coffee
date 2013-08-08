class window.VoteUpDownBaseView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  events:
    "click .js-up":   "_on_up_vote"
    "click .js-down": "_on_down_vote"

  constructor: ->
    super
    @listenTo @model, "change", @render

  templateHelpers: =>
    interactive: @interactive()

  onRender: ->
    @renderActive() if @interactive()

  renderActive: ->
    @$('a.js-up').addClass('active') if @model.get('current_user_opinion') == 'believes'
    @$('a.js-down').addClass('active')  if @model.get('current_user_opinion') == 'disbelieves'

  _on_up_vote: ->
    return unless @interactive()
    mp_track "Factlink: Upvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @_open_vote_popup '.js-up', FactRelationVoteUpView
    else
      if @model.isBelieving()
        @model.removeOpinion()
      else
        @model.believe()

  _on_down_vote: ->
    return unless @interactive()
    mp_track "Factlink: Downvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @_open_vote_popup '.js-down',  FactRelationVoteDownView
    else
      if @model.isDisBelieving()
        @model.removeOpinion()
      else
        @model.disbelieve()

  _open_vote_popup: (selector, view_klass) ->
    return if @popoverOpened selector

    @popoverResetAll()
    @popoverAdd selector,
      side: @side()
      align: 'top'
      fadeTime: 40
      contentView: @_bound_popup_view view_klass

  _bound_popup_view: (view_klass) ->
    view = new view_klass model: @model

    @listenTo view, 'saved', ->
      @popoverResetAll()

    view

class window.VoteUpDownView extends VoteUpDownBaseView
  className: "evidence-actions"
  template: "evidence/vote_up_down"

  interactive: -> @options.interactive
  side: -> 'right'

class window.NDPEvidenceVoteView extends VoteUpDownBaseView
  className: 'evidence-impact-vote'
  template: 'evidence/ndp_evidence_vote'

  interactive: -> true

  side: ->
    if @model.get('type') == 'believes'
      'left'
    else
      'right'
