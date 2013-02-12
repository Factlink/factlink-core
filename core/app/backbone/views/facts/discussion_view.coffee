class window.DiscussionView extends Backbone.Marionette.Layout
  tagName: "section"

  template: "facts/discussion"

  regions:
    factView: ".fact-region"
    factRelationTabsView: ".fact-relations-region"

  onRender: ->
    @factView.show new FactView(model: @model)

    @factRelationTabsView.show new FactRelationTabsView(model: @model, tab: @options.tab)
