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

    @listenTo @model, 'change', ->
      wheel.setRecursive @model.get("fact_wheel")
      wheelView.render()

    wheelView

  bodyView: ->
    @_bodyView ?= new FactBodyView
      model: @model
      clickable: @options.clickable_body
      truncate: @options.truncate_body

class FactBodyView extends Backbone.Marionette.ItemView
  _.extend @prototype, Backbone.Factlink.Trunk8MoreLessMixin

  template: "facts/fact_body"

  events:
    "click span.js-displaystring": "click"

  ui:
    displaystring: '.js-displaystring'

  initialize: ->
    @options.truncate = false if @options.clickable

    @trunk8Init 3, '.js-displaystring', '.less' if @options.truncate
    @listenTo @model, 'change', @render

  click: ->
    if FactlinkApp.modal
      Backbone.history.navigate @model.clientLink(), true
    else
      FactlinkApp.DiscussionModalOnFrontend.openDiscussion @model.clone()

  onRender: ->
    @ui.displaystring.toggleClass 'fact-body-displaystring-clickable', !!@options.clickable
