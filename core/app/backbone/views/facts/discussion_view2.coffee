class window.DiscussionView2 extends Backbone.Marionette.Layout
  tagName: 'section'

  template: 'facts/discussion2'

  regions:
    factRegion: '.fact-region'

  onRender: ->
    @factRegion.show new FactView2(model: @model)
