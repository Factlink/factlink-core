class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  showLines: 3

  regions:
    factWheelRegion: '.fact-wheel'

  events:
    "click a.more": "showCompleteDisplaystring"
    "click a.less": "hideCompleteDisplaystring"

  onRender: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @truncateText()
    )

    @factWheelRegion.show @wheelView()

  initialize: ->
    @bindTo @model, 'change', @render, @

  truncateText: ->
    @$('.fact-body').trunk8
      fill: " <a class=\"more\">(more)</a>"
      lines: @showLines

  showCompleteDisplaystring: (e) ->
    @$('.fact-body').trunk8 lines: 199
    @$('.fact-body .less').show()

  hideCompleteDisplaystring: (e) ->
    @$('.fact-body').trunk8 lines: @showLines
    @$('.fact-body .less').hide()

  wheelView: ->
    wheel = new Wheel(@model.get("fact_base")["fact_wheel"])
    @_wheelView = new InteractiveWheelView
      fact: @model.get("fact_base")
      model: wheel

    @bindTo @model, 'change', =>
      wheel.set @model.get("fact_base")["fact_wheel"]
      @_wheelView.render()

    @_wheelView
