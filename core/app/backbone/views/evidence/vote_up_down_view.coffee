class window.VoteUpDownView extends Backbone.Marionette.ItemView
  className: "evidence-actions"

  template: "evidence/vote_up_down"

  constructor: ->
    super
    @bindTo @model, "change", @render, @

class window.InteractiveVoteUpDownView extends window.VoteUpDownView

  events:
    "click .supporting": "on_up_vote"
    "click .weakening":  "on_down_vote"

  templateHelpers: -> interactive: true

  onRender: ->
    @renderActive()

  renderActive: ->
    @$('a.supporting').addClass('active') if @current_opinion() == 'believes'
    @$('a.weakening').addClass('active')  if @current_opinion() == 'disbelieves'

  current_opinion: ->

  on_up_vote: ->
    mp_track "Factlink: Upvote evidence click"

  on_down_vote: ->
    mp_track "Factlink: Downvote evidence click"


class window.InteractiveVoteUpDownFactRelationView extends window.InteractiveVoteUpDownView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  current_opinion: -> @model.get('current_user_opinion')

  on_up_vote: ->
    super
    @open_vote_popup '.supporting', FactRelationVoteUpView

  on_down_vote: ->
    super
    @open_vote_popup '.weakening', FactRelationVoteDownView

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

class window.InteractiveVoteUpDownCommentView extends window.InteractiveVoteUpDownView

  current_opinion: -> @model.get('current_user_opinion')

  on_up_vote: ->
    super
    if @model.isBelieving()
      @model.removeOpinion()
    else
      @model.believe()

  on_down_vote: ->
    super
    if @model.isDisBelieving()
      @model.removeOpinion()
    else
      @model.disbelieve()
