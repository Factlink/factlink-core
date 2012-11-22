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
      add_comment_view: => @addCommentView()

  onRender: ->
    @inputRegion.switchTo 'search_view'

  searchView: ->
    searchView = new AutoCompleteFactRelationsView
      collection: @collection
    @bindTo searchView, 'selected', (fact_relation) =>
      @inputRegion.getView('preview_view').model.set(fact_relation.attributes)
      @inputRegion.switchTo 'preview_view'
    @bindTo searchView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)

    @bindTo searchView, 'switch_to_comment_view', @switchToCommentView, @


    searchView

  previewView: ->
    previewView = new FactRelationPreviewView
      model: new FactRelation
    @bindTo previewView, 'cancel', =>
      @inputRegion.switchTo 'search_view'
    @bindTo previewView, 'createFactRelation', (fact_relation) =>
      @createFactRelation(fact_relation)
    previewView

  addCommentView: ->
    addCommentView = new AddCommentView( addToCollection: @model.comments(), type: @model.type() )
    @bindTo addCommentView, 'switch_to_fact_relation_view', @switchToFactRelationView, @

    addCommentView

  createFactRelation: (fact_relation)->
    @hideError()
    @collection.add fact_relation
    @inputRegion.switchTo('search_view')
    @inputRegion.getView('search_view').setQuery ''
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
