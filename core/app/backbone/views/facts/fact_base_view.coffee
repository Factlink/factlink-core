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

  wheelView: ->
    wheel = @model.getFactWheel()

    if Factlink.Global.signed_in
      wheelView = new InteractiveWheelView
        fact: @model.attributes
        model: wheel
    else
      wheelView = new BaseFactWheelView
        fact: @model.attributes
        model: wheel
        respondsToMouse: false

    @bindTo @model, 'change', =>
      wheel.setRecursive @model.get("fact_wheel")
      wheelView.render()

    wheelView

  bodyView: ->
    bodyView = new FactBodyView
      model: @model
      clickable: @options.clickable_body

    @bindTo bodyView, 'click:body', (e) =>
      @trigger 'click:body', e

    bodyView

class FactBodyView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.Trunk8MoreLessMixin

  template: "facts/fact_body"

  events:
    "click span.js-displaystring": "triggerViewClick"

  ui:
    displaystring: '.js-displaystring'

  initialize: ->
    @trunk8Init 3, '.js-displaystring', '.less'
    @bindTo @model, 'change', @render, @

  triggerViewClick: (e) ->
    @trigger 'click:body', e

  onRender: ->
    @ui.displaystring.toggleClass 'fact-body-displaystring-clickable', @options.clickable || false
