class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form'
  template: 'evidence/add_evidence_form'

  regions:
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  initialize: ->
    @_recent_collection = new RecentlyViewedFacts
    @_recent_collection.fetch()

    @inputRegion.defineViews
      search_view: => @searchView()
      add_comment_view: => @addCommentView()

  onRender: ->
    @switchToCommentView()

  _filtered_facts: ->
    fact_relations_masquerading_as_facts = @_collectionUtils().map new Backbone.Collection,
      @collection, (model) -> new Fact model.get('from_fact')

    @_collectionUtils().union new Backbone.Collection, fact_relations_masquerading_as_facts,
      new Backbone.Collection [@collection.fact.clone()]

  _collectionUtils: ->
    @_____collectionUtils ?= new CollectionUtils this

  searchView: ->
    searchView = new AutoCompleteFactRelationsView
      collection: @_filtered_facts()
      fact_id: @collection.fact.id
      type: @collection.believesType()
      recent_collection: @_recent_collection
    @listenTo searchView, 'createFactRelation', (fact_relation, onFinish) ->
      @createFactRelation(fact_relation, onFinish)
    @listenTo searchView, 'switch_to_comment_view', @switchToCommentView
    searchView

  addCommentView: ->
    addCommentView = new AddCommentView
      addToCollection: @collection
      type: @options.type
    @listenTo addCommentView, 'switch_to_fact_relation_view', @switchToFactRelationView

    addCommentView

  createFactRelation: (fact_relation, onFinish=->)->
    return @showError() unless fact_relation.isValid()

    @collection.add fact_relation
    @inputRegion.switchTo('search_view')

    @collection.trigger 'start_adding_model'
    fact_relation.save {},
      error: =>
        onFinish()
        @collection.remove fact_relation
        @collection.trigger 'error_adding_model'
        @showError()

      success: =>
        onFinish()
        @inputRegion.getView('search_view').reset()
        @collection.trigger 'saved_added_model'

        mp_track "Evidence: Added",
          factlink_id: @options.fact_id
          type: @options.type

  switchToCommentView: ->
    @inputRegion.switchTo 'add_comment_view'

  switchToFactRelationView: ->
    @inputRegion.switchTo 'search_view'

  showError: -> FactlinkApp.NotificationCenter.error 'Your Factlink could not be posted, please try again.'
