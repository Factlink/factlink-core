class window.DiscussionView extends Backbone.Marionette.Layout
  className: 'discussion'

  template: 'facts/discussion'

  regions:
    factRegion: '.js-fact-region'
    evidenceRegion: '.js-evidence-region'

  onRender: ->

    @factRegion.show new TopFactView model: @model

    @evidenceRegion.show new EvidenceContainerView
      collection: @model.comments()
