class window.DiscussionView2 extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'discussion2'

  template: 'facts/discussion2'

  regions:
    factRegion: '.fact-region'
    argumentsRegion: '.arguments-region'

  onRender: ->
    @factRegion.show new TopFactView(model: @model)
    @argumentsRegion.show new TopFactArgumentsView(model: @model)
