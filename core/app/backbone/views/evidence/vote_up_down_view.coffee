class window.VoteUpDownView extends Backbone.Marionette.ItemView
  className: "evidence-actions"

  template: "evidence/vote_up_down"

  initialize: ->
    @bindTo @model, "change", @render, @

class window.InteractiveVoteUpDownView extends window.VoteUpDownView

  events:
    "click .supporting": "on_up_vote"
    "click .weakening":  "on_down_vote"

  templateHelpers: -> interactive: true

  hideTooltips: ->
    @$(".weakening").tooltip "hide"
    @$(".supporting").tooltip "hide"

  onRender: ->
    @renderTooltips()
    @renderActive()

  renderTooltips: ->
    @$(".supporting").tooltip
      title: "This is relevant"

    @$(".weakening").tooltip
      title: "This is not relevant"
      placement: "bottom"

  renderActive: ->
    @$('a.supporting').addClass('active') if @current_opinion() == 'believes'
    @$('a.weakening').addClass('active')  if @current_opinion() == 'disbelieves'

  current_opinion: ->

  onBeforeClose: ->
    @$(".weakening").tooltip "destroy"
    @$(".supporting").tooltip "destroy"

  on_up_vote: ->
    @hideTooltips()
    mp_track "Factlink: Upvote evidence click"

  on_down_vote: ->
    @hideTooltips()
    mp_track "Factlink: Downvote evidence click"


class window.InteractiveVoteUpDownFactRelationView extends window.InteractiveVoteUpDownView
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  current_opinion: ->
    @model.get('current_user_opinion')

  on_up_vote: ->
    @popoverRemove '.weakening', false

    fact_relation_vote_up_view = new FactRelationVoteUpView model: @model
    @bindTo fact_relation_vote_up_view, 'saved', => @popoverRemove '.supporting'

    @popoverAdd '.supporting',
      side: 'right'
      align: 'center'
      contentView: fact_relation_vote_up_view

  on_down_vote: ->
    @popoverRemove '.supporting', false

    fact_relation_vote_down_view = new FactRelationVoteDownView model: @model
    @bindTo fact_relation_vote_down_view, 'saved', => @popoverRemove '.weakening'

    @popoverAdd '.weakening',
      side: 'right'
      align: 'center'
      contentView: fact_relation_vote_down_view

class window.InteractiveVoteUpDownCommentView extends window.InteractiveVoteUpDownView

  current_opinion: ->
    @model.get('current_user_opinion')

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
