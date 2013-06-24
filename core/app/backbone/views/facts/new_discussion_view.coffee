class window.NewDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'

  template: 'facts/new_discussion'

  regions:
    factView: '.fact-region'

  onRender: ->
    @factView.show new NewFactView(model: @model)
