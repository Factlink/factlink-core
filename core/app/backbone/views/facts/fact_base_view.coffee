class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  regions:
    factWheelRegion: '.fact-wheel'
    factBodyRegion: '.fact-body'

  onRender: ->
    @factWheelRegion.show @wheelView()
    @factBodyRegion.show @bodyView()

  initialize: ->
    @bindTo @model, 'change', =>
      @factBodyRegion.currentView?.render()

  wheelView: ->
    wheel = new Wheel(@model.get("fact_base")["fact_wheel"])
    wheelView = new InteractiveWheelView
      fact: @model.get("fact_base")
      model: wheel

    @bindTo @model, 'change', =>
      wheel.setRecursive @model.get("fact_base")["fact_wheel"]
      wheelView.render()

    wheelView

  bodyView: ->
    bodyView = new FactBodyView(model:@model)

    @bindTo bodyView, 'click:body', =>
      @trigger 'click:body'

    bodyView

class FactBodyView extends Backbone.Marionette.ItemView
  template: "facts/fact_body"

  showLines: 3

  events:
    "click a.more": "showCompleteDisplaystring"
    "click a.less": "hideCompleteDisplaystring"
    "click span.js-displaystring": "triggerViewClick"

  onRender: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @truncateText()
    )

  truncateText: ->
    @$('.js-displaystring').trunk8
      fill: " <a class=\"more\">(more)</a>"
      lines: @showLines

  showCompleteDisplaystring: (e) ->
    @$('.js-displaystring').trunk8 lines: 199
    @$('.less').show()
    e.stopPropagation()

  hideCompleteDisplaystring: (e) ->
    @$('.js-displaystring').trunk8 lines: @showLines
    @$('.less').hide()
    e.stopPropagation()

  triggerViewClick: ->
    @trigger 'click:body'
