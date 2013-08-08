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
      new Fact model.get('from_fact')

  searchView: ->
    searchView = new AutoCompleteFactRelationsView
      recent_collection: @recentCollection()
      collection: @fact_relations_masquerading_as_facts()
      fact_id: @collection.fact.id
      type: @collection.type
    @listenTo searchView, 'createFactRelation', (fact_relation, onFinish) ->
      @createFactRelation(fact_relation, onFinish)
    @listenTo searchView, 'switch_to_comment_view', @switchToCommentView
    searchView

  addCommentView: ->
    addCommentView = new AddCommentView( addToCollection: @model.evidence(), type: @model.type() )
    @listenTo addCommentView, 'switch_to_fact_relation_view', @switchToFactRelationView

    addCommentView

  fact: ->
    @model.fact()

  recentlyViewedFactsView: ->
    unless @_recentFactsView?
      collectionUtils = new CollectionUtils(this)
      filtered_recent_facts = collectionUtils.difference new Backbone.Collection,
        'id', @recentCollection(),
              @fact_relations_masquerading_as_facts(),
              new Backbone.Collection [@fact()]

      @_recentFactsView = new RecentlyViewedFactsView
        collection: filtered_recent_facts
        evidence_type: @collection.type

      @listenTo @_recentFactsView, 'itemview:click', @addRecentFact

    @_recentFactsView

  createFactRelation: (fact_relation, onFinish=->)->
    return @showError() unless fact_relation.isValid()

    @hideError()
    @collection.add fact_relation, highlight: true
    @inputRegion.switchTo('search_view')

    fact_relation.save {},
      error: =>
        onFinish()
        @collection.remove fact_relation
        @showError()

      success: =>
        onFinish()
        @inputRegion.getView('search_view').reset()

        mp_track "Evidence: Added",
          factlink_id: @model.fact().id
          type: @model.type()

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

  addFromFact: (from_fact)->
    @createFactRelation new FactRelation
      evidence_id: from_fact.id
      from_fact: from_fact
      created_by: currentUser.toJSON()

  addRecentFact: (args) ->
    @addFromFact args.model.attributes

