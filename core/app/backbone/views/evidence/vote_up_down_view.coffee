class window.VoteUpDownView extends Backbone.Marionette.ItemView
  className: "evidence-actions"

  template: "evidence/vote_up_down"

  initialize: ->
    @bindTo @model, "change", @render, @

class window.InteractiveVoteUpDownView extends window.VoteUpDownView
  events:
    "click .weakening": "disbelieve"
    "click .supporting": "believe"

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
    if @model.get('current_user_opinion') == 'believes'
      @$('a.supporting').addClass('active')
    if @model.get('current_user_opinion') == 'disbelieves'
      @$('a.weakening').addClass('active')

  onBeforeClose: ->
    @$(".weakening").tooltip "destroy"
    @$(".supporting").tooltip "destroy"

  disbelieve: ->
    @hideTooltips()

    if @model.isDisBelieving()
      @model.removeOpinion()
    else
      @model.disbelieve()

  believe: ->
    @hideTooltips()

    if @model.isBelieving()
      @model.removeOpinion()
    else
      @model.believe()
