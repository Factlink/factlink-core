class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  regions:
    factWheelRegion: '.fact-wheel'
    factBodyRegion: '.fact-body'

  onRender: ->
    @factWheelRegion.show @wheelView() unless Factlink.Global.can_haz.hide_factwheel
    @factBodyRegion.show @bodyView()

  wheelView: ->
    tally = @model.getFactTally()

    wheelView = new FactWheelView
      fact: @model.attributes
      model: tally
      respondsToMouse: Factlink.Global.signed_in

    @listenTo @model, 'change', ->
      tally.set @model.get("tally")
      wheelView.render()

    wheelView

  bodyView: ->
    @_bodyView ?= new FactBodyView
      model: @model

class FactBodyView extends Backbone.Marionette.ItemView
  template: "facts/fact_body"

  events:
    "click span.js-displaystring": "click"

  ui:
    displaystring: '.js-displaystring'

  initialize: ->
    @listenTo @model, 'change', @render

  click: (e) ->
    if e.metaKey or e.ctrlKey or e.altKey
      window.open @model.get('url'), "_blank"
    else if FactlinkApp.onClientApp
      Backbone.history.navigate @model.clientLink(), true
    else
      FactlinkApp.DiscussionModalOnFrontend.openDiscussion @model.clone(), e
