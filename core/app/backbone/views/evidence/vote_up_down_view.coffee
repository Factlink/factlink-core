class window.VoteUpDownView extends Backbone.Marionette.ItemView

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
    @$('a.supporting').addClass('active') if @current_opinion() == 'believes'
    @$('a.weakening').addClass('active')  if @current_opinion() == 'disbelieves'

  _on_up_vote: ->
    return unless @options.interactive
    mp_track "Factlink: Upvote evidence click"
    @on_up_vote()

  _on_down_vote: ->
    return unless @options.interactive
    mp_track "Factlink: Downvote evidence click"
    @on_down_vote()
