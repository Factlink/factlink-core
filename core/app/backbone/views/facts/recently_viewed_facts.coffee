class RecentlyViewedFactView extends Backbone.Marionette.Layout
  tagName: 'li'
  template: 'facts/recently_viewed_fact'

  regions:
    factBaseRegion: '.js-region-fact-base'

  templateHelpers: =>
    evidence_type: @options.evidence_type

  triggers:
    'click button': 'click'

  factBaseView: ->
    console.info @model
    @_factBaseView ?= new FactBaseView
      model: @model

  onRender: ->
    @factBaseRegion.show @factBaseView()

class window.RecentlyViewedFactsView extends Backbone.Marionette.CompositeView
  template: 'facts/recently_viewed_facts'

  className: 'recently-viewed-facts'

  itemView: RecentlyViewedFactView
  itemViewContainer: '.js-itemview-container'
  itemViewOptions: -> evidence_type: @options.evidence_type
