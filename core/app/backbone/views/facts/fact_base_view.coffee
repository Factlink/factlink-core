class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  regions:
    factWheelRegion: '.fact-wheel'
    factBodyRegion: '.fact-body'

  templateHelpers: ->
    'modal?' : FactlinkApp.modal is true

  onRender: ->
    @factWheelRegion.show @wheelView()
    @factBodyRegion.show @bodyView()

  initialize: ->
    @bindTo @model, 'change', =>
      @factBodyRegion.currentView?.render()

  wheelView: ->
    wheel = new Wheel(@model.get("fact_base")["fact_wheel"])

    wheelViewClass = if Factlink.Global.signed_in then InteractiveWheelView else BaseFactWheelView
    wheelView = new wheelViewClass
      fact: @model.get("fact_base")
      model: wheel

    @bindTo @model, 'change', =>
      wheel.setRecursive @model.get("fact_base")["fact_wheel"]
      wheelView.render()

    wheelView

  bodyView: ->
    bodyView = new FactBodyView(model:@model)

    @bindTo bodyView, 'click:body', (e) =>
      @trigger 'click:body', e

    bodyView

class FactBodyView extends Backbone.Marionette.ItemView
  template: "facts/fact_body"

  events:
    "click span.js-displaystring": "triggerViewClick"

  initialize: ->
    @trunk8Init 3, '.js-displaystring', '.less'

  triggerViewClick: (e) ->
    @trigger 'click:body', e

_.extend(FactBodyView.prototype, Backbone.Factlink.Trunk8MoreLessMixin)
