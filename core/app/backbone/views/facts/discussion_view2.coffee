class window.DiscussionView2 extends Backbone.Marionette.Layout
  tagName: 'section'
  className: 'discussion2'

  template: 'facts/discussion2'

  regions:
    factRegion: '.fact2-region'
    evidenceRegion: '.evidence-region'

  onRender: ->
    @factRegion.show new TopFactView(model: @model)
    @evidenceRegion.show new TopFactEvidenceView(model: @model)
