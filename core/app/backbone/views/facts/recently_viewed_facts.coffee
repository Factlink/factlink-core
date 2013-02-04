class RecentlyViewedFactView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template: 'facts/recently_viewed_fact'

  templateHelpers: =>
    evidence_type: @options.evidence_type

  triggers:
    'click button': 'click'

  ui:
    factWheel: '.js-fact-wheel'

  onRender: ->
    @ui.factWheel.html @wheelView().render().el

  onClose: ->
    @wheelView().close()

  wheelView: ->
    @_wheelView ?= new InteractiveWheelView
      fact: @model.get("fact_base")
      model: new Wheel @model.get("fact_wheel")

class window.RecentlyViewedFactsView extends Backbone.Marionette.CompositeView
  template: 'facts/recently_viewed_facts'

  className: 'recently-viewed-facts'

  itemView: RecentlyViewedFactView
  itemViewContainer: '.js-itemview-container'
  itemViewOptions: -> evidence_type: @options.evidence_type
