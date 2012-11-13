class window.DiscussionView extends Backbone.Marionette.Layout
  tagName: "section"

  template: "facts/discussion"

  regions:
    factView: "#fact-block",

  onRender: ->
    @factView.show new FactView(model: @model)
