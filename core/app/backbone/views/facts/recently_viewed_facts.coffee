class RecentlyViewedFactView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: 'facts/recently_viewed_fact'

  templateHelpers: =>
    evidence_type: @options.evidence_type

  triggers:
    'click button': 'click'

class window.RecentlyViewedFactsView extends Backbone.Marionette.CompositeView
  template: 'facts/recently_viewed_facts'

  className: 'recently-viewed-facts'

  itemView: RecentlyViewedFactView
  itemViewContainer: '.js-itemview-container'
  itemViewOptions: -> evidence_type: @options.evidence_type
