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

  events:
    "click span.js-displaystring": "triggerViewClick"

  initialize: ->
    @trunk8Init 3

  triggerViewClick: ->
    @trigger 'click:body'

_.extend(FactBodyView.prototype, Backbone.Factlink.Trunk8MoreLessMixin)
