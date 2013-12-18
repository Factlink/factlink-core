class window.DiscussionView extends Backbone.Marionette.Layout
  className: 'discussion'

  template: 'facts/discussion'

  regions:
    factRegion: '.js-fact-region'
    evidenceRegion: '.js-evidence-region'

  onRender: ->
    @listenTo @model, 'destroy', -> FactlinkApp.vent.trigger 'close_discussion_modal'

    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new EvidenceCollection null, fact: @model
    opinionaters_collection.fetch()

    @evidenceRegion.show new EvidenceContainerView
      collection: opinionaters_collection
