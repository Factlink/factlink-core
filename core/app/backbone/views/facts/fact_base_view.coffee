class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  regions:
    factWheelRegion: '.fact-wheel'
    factBodyRegion: '.fact-body'

  onRender: ->
    @factWheelRegion.show @wheelView()
    @factBodyRegion.show new FactBodyView(model:@model)

  initialize: ->
    @bindTo @model, 'change', =>
      @factWheelRegion.currentView?.render()
      @factBodyRegion.currentView?.render()
    , @

  wheelView: ->
    wheel = new Wheel(@model.get("fact_base")["fact_wheel"])
    wheelView = new InteractiveWheelView
      fact: @model.get("fact_base")
      model: wheel

    @bindTo @model, 'change', =>
      wheel.set @model.get("fact_base")["fact_wheel"]
      wheelView.render()

    wheelView

class FactBodyView extends Backbone.Marionette.ItemView
  template: "facts/fact_body"

  showLines: 3

  events:
    "click a.more": "showCompleteDisplaystring"
    "click a.less": "hideCompleteDisplaystring"

  onRender: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @truncateText()
    )

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
