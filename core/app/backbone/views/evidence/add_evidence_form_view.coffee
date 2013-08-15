class window.AddEvidenceFormView extends Backbone.Marionette.Layout
  className: 'add-evidence-form'
  template: 'evidence/add_evidence'

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
    @$el.addClass 'pre-ndp-add-evidence-form' unless @options.ndp

    @switchToCommentView()

  fact_relations_masquerading_as_facts: ->
    @_fact_relations_masquerading_as_facts ?= collectionMap new Backbone.Collection, @collection, (model) ->
      new Fact model.get('from_fact')

  searchView: ->
    searchView = new AutoCompleteFactRelationsView
      collection: @fact_relations_masquerading_as_facts()
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
      ndp: @options.ndp
    @listenTo addCommentView, 'switch_to_fact_relation_view', @switchToFactRelationView

    addCommentView

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
          factlink_id: @options.fact_id
          type: @options.type

  switchToCommentView: (content) ->
    @inputRegion.switchTo 'add_comment_view'
    @inputRegion.getView('add_comment_view').setFormContent(content) if content

  switchToFactRelationView: (content) ->
    @inputRegion.switchTo 'search_view'
    @inputRegion.getView('search_view').setQuery(content) if content

  showError: -> @$('.js-error').show()
  hideError: -> @$('.js-error').hide()
