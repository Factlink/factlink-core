class window.AddEvidenceView extends Backbone.Marionette.Layout
  template: 'fact_relations/add_evidence'

  regions:
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  # TODO remove on updating marionette
  initialEvents: -> # don't rerender on collection change

  # TODO: remove this when updating Marionette
  # In the current version the order is the other way around
  constructor: ->
    this.initializeRegions()
    Backbone.Marionette.ItemView.apply(this, arguments)

  initialize: ->
    @inputRegion.defineViews
      search_view: => @searchView()
      preview_view: => @previewView()

  onRender: ->
    @inputRegion.switchTo 'search_view'

  searchView: ->
    fact_relations_masquerading_as_facts = collectionMap new Backbone.Collection, @collection, (model) ->
      new Fact model.get('fact_base')
    searchView = new AutoCompleteFactRelationsView
      collection: fact_relations_masquerading_as_facts
      fact_id: @collection.fact.id
      type: @collection.type
    @bindTo searchView, 'selected', (fact_relation) =>
      @inputRegion.getView('preview_view').model.set(fact_relation.attributes)
      @inputRegion.switchTo 'preview_view'
    @bindTo searchView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)
    searchView

  previewView: ->
    previewView = new FactRelationPreviewView
      model: new FactRelation
    @bindTo previewView, 'cancel', =>
      @inputRegion.switchTo 'search_view'
    @bindTo previewView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)
    previewView

  createFactRelation: (fact_relation)->
    @hideError()
    @collection.add fact_relation
    @inputRegion.switchTo('search_view')
    @inputRegion.getView('search_view').reset()
    fact_relation.save {},
      error: =>
        @collection.remove fact_relation
        @inputRegion.getView('search_view').setQuery fact_relation.get('fact_base').displaystring
        @showError()

  showError: -> @$('.js-error').show()
  hideError: -> @$('.js-error').hide()
