class window.AddEvidenceView extends Backbone.Marionette.Layout
  template: 'fact_relations/add_evidence'

  regions:
    inputRegion:
      selector: '.input-region'
      regionType: Factlink.DetachableViewsRegion

  initialize: ->
    @inputRegion.defineViews
      search_view: => @searchView()
      add_comment_view: => @addCommentView()

  onRender: ->
    @inputRegion.switchTo 'search_view'

  searchView: ->
    fact_relations_masquerading_as_facts = collectionMap new Backbone.Collection, @collection, (model) ->
      new Fact model.get('fact_base')
    searchView = new AutoCompleteFactRelationsView
      collection: fact_relations_masquerading_as_facts
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

  switchToFactRelationView: (content) ->
    @inputRegion.switchTo 'search_view'
    @inputRegion.getView('search_view').setQuery(content) if content

  showError: -> @$('.js-error').show()
  hideError: -> @$('.js-error').hide()
