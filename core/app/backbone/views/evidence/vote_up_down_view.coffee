class window.VoteUpDownView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: "evidence-actions"

  template: "evidence/vote_up_down"

  events:
    "click .supporting": "_on_up_vote"
    "click .weakening":  "_on_down_vote"

  constructor: ->
    super
    @bindTo @model, "change", @render, @

  templateHelpers: =>
    interactive: @options.interactive ? true

  onRender: ->
    @renderActive() if @options.interactive

  renderActive: ->
    @$('a.supporting').addClass('active') if @model.get('current_user_opinion') == 'believes'
    @$('a.weakening').addClass('active')  if @model.get('current_user_opinion') == 'disbelieves'

  _on_up_vote: ->
    return unless @options.interactive
    mp_track "Factlink: Upvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @open_vote_popup '.supporting', FactRelationVoteUpView
    else
      if @model.isBelieving()
        @model.removeOpinion()
      else
        @model.believe()

  _on_down_vote: ->
    return unless @options.interactive
    mp_track "Factlink: Downvote evidence click"
    if @model instanceof FactRelation && Factlink.Global.can_haz['vote_up_down_popup']
      @open_vote_popup '.weakening',  FactRelationVoteDownView
    else
      if @model.isDisBelieving()
        @model.removeOpinion()
      else
        @model.disbelieve()

  open_vote_popup: (selector, view_klass) ->
    return if @popoverOpened selector

    @popoverResetAll()
    @popoverAdd selector,
      side: 'right'
      align: 'top'
      fadeTime: 40
      contentView: @bound_popup_view view_klass

  bound_popup_view: (view_klass) ->
    view = new view_klass model: @model

    @bindTo view, 'saved', =>
      @popoverResetAll()

    view
