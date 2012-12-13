class window.VoteUpDownView extends Backbone.Marionette.ItemView
  className: "evidence-actions"

  template: "evidence/vote_up_down"

  events:
    "click .weakening": "disbelieve"
    "click .supporting": "believe"

  initialize: ->
    @bindTo @model, "change", @render, @

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
