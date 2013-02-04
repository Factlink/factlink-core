class RecentlyViewedFactView extends Backbone.Marionette.ItemView
  tagName: 'li'
  template:
    text: """
      Fact: {{displaystring}}
      <button class="pull-right btn btn-mini">+ add as {{evidence_type}}</button>
    """

  templateHelpers: =>
    evidence_type: @options.evidence_type

  triggers:
    'click button': 'click'

class RecentlyViewedFactsView extends Backbone.Marionette.CompositeView
  template:
    text: """
    <strong>Recent Factlinks:</strong>
    <ul class="js-itemview-container"></ul>
    """

  className: 'recently-viewed-facts'

  itemView: RecentlyViewedFactView
  itemViewContainer: '.js-itemview-container'
  itemViewOptions: -> evidence_type: @options.evidence_type


class window.AddEvidenceView extends Backbone.Marionette.Layout
  template: 'fact_relations/add_evidence'

  regions:
    recentsRegion: '.js-region-recents'
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  initialize: ->
    @inputRegion.defineViews
      search_view: => @searchView()
      add_comment_view: => @addCommentView()

  onRender: ->
    @recentsRegion.show @recentlyViewedFactsView()
    @switchToFactRelationView()

  fact_relations_masquerading_as_facts: ->
    @_fact_relations_masquerading_as_facts ?= collectionMap new Backbone.Collection, @collection, (model) ->
      new Fact model.get('fact_base')

  searchView: ->
    searchView = new AutoCompleteFactRelationsView
      recent_collection: @recentCollection()
      collection: @fact_relations_masquerading_as_facts()
      fact_id: @collection.fact.id
      type: @collection.type
    @bindTo searchView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)
    @bindTo searchView, 'switch_to_comment_view', @switchToCommentView, @
    searchView

  addCommentView: ->
    addCommentView = new AddCommentView( addToCollection: @model.evidence(), type: @model.type() )
    @bindTo addCommentView, 'switch_to_fact_relation_view', @switchToFactRelationView, @

    addCommentView

  recentlyViewedFactsView: ->
    unless @_recentFactsView?
      collectionUtils = new CollectionUtils(this)
      filtered_recent_facts = collectionUtils.difference new Backbone.Collection,
        'id', @recentCollection(), @fact_relations_masquerading_as_facts()

      @_recentFactsView = new RecentlyViewedFactsView
        collection: filtered_recent_facts
        evidence_type: @collection.type

      @bindTo @_recentFactsView, 'itemview:click', @addRecentFact, @

    @_recentFactsView

  createFactRelation: (fact_relation)->
    @hideError()
    @collection.add fact_relation, highlight: true
    @inputRegion.switchTo('search_view')
    @inputRegion.getView('search_view').reset()
    fact_relation.save {},
      error: =>
        @collection.remove fact_relation
        @inputRegion.getView('search_view').setQuery fact_relation.get('fact_base').displaystring
        @showError()

  switchToCommentView: (content) ->
    @inputRegion.switchTo 'add_comment_view'
    @inputRegion.getView('add_comment_view').setFormContent(content) if content
    @recentsRegion.$el.addClass 'hide'

  switchToFactRelationView: (content) ->
    @inputRegion.switchTo 'search_view'
    @inputRegion.getView('search_view').setQuery(content) if content
    @recentsRegion.$el.removeClass 'hide'

  showError: -> @$('.js-error').show()
  hideError: -> @$('.js-error').hide()

  recentCollection: ->
    unless @_recent_collection?
      @_recent_collection = new RecentlyViewedFacts
      @_recent_collection.fetch()
    @_recent_collection

  addFactBase: (fact_base)->
    @createFactRelation new FactRelation
      evidence_id: fact_base.id
      fact_base: fact_base.toJSON()
      created_by: currentUser.toJSON()

  addRecentFact: (args) ->
    @addFactBase args.model

