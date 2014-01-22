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
      FactlinkApp.DiscussionSidebarOnFrontend.openDiscussion @model, e
