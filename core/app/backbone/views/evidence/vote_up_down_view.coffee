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
    @open_vote_up_popup()

  on_down_vote: ->
    @open_vote_down_popup()

  default_popover_options: ->
    side: 'right'
    align: 'top'

  open_vote_up_popup: ->
    return if @_up_is_opened

    @close_vote_down_popup() if @_down_is_opened
    @_up_is_opened = true

    popover_options = _.extend {}, @default_popover_options(),
                               contentView: @fact_relation_vote_up_view()

    @popoverAdd '.supporting', popover_options

  fact_relation_vote_up_view: ->
    view = new FactRelationVoteUpView model: @model

    @bindTo view, 'saved', =>
      @close_vote_up_popup()
    view

  open_vote_down_popup: ->
    return if @_down_is_opened

    @close_vote_up_popup() if @_up_is_opened
    @_down_is_opened = true

    popover_options = _.extend {}, @default_popover_options(),
                               contentView: @fact_relation_vote_down_view()

    @popoverAdd '.weakening', popover_options

  fact_relation_vote_down_view: ->
    view = new FactRelationVoteDownView model: @model
    @bindTo view, 'saved', =>
      @close_vote_down_popup()
    view

  close_vote_up_popup: ->
    @popoverRemove '.supporting', false
    @_up_is_opened = false

  close_vote_down_popup: ->
    @popoverRemove '.weakening', false
    @_down_is_opened = false

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
