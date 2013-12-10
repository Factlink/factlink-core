class window.DiscussionView extends Backbone.Marionette.Layout
  className: 'discussion'

  template: 'facts/discussion'

  regions:
    factRegion: '.js-region-fact'
    evidenceRegion: '.js-region-evidence'

  onRender: ->
    if Factlink.Global.can_haz.comments_no_opinions
      @$el.addClass 'feature_comments_no_opinions'

    @listenTo @model, 'destroy', -> FactlinkApp.vent.trigger 'close_discussion_modal'

    @factRegion.show new TopFactView model: @model

    opinionaters_collection = new EvidenceCollection null, fact: @model
    opinionaters_collection.fetch()

    @evidenceRegion.show new EvidenceContainerView
      collection: opinionaters_collection
