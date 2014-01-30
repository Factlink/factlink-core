class window.FactBaseView extends Backbone.Marionette.Layout
  template: 'facts/fact_base'
  className: "fact-base"

  regions:
    factBodyRegion: '.fact-body'

  onRender: ->
    @factBodyRegion.show @bodyView()

  bodyView: ->
    @_bodyView ?= new FactBodyView
      model: @model

class FactBodyView extends Backbone.Marionette.ItemView
  template: "facts/fact_body"

  initialize: ->
    @listenTo @model, 'change', @render
