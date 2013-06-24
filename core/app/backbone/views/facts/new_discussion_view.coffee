class window.NewDiscussionView extends Backbone.Marionette.Layout
  tagName: 'section'

  template: 'facts/new_discussion'

  regions:
    factRegion: '.fact-region'

  onRender: ->
    @factRegion.show new NewFactView(model: @model)
