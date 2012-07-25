class window.FactRelationsView extends Backbone.Factlink.PlainView
  tagName: "div"
  className: "page evidence-list fact-relations-container"
  template: "fact_relations/fact_relations"
  initialize: (options) ->
    @_views = []
    @collection.bind "add", @addFactRelation, this
    @collection.bind "reset", @resetFactRelations, this
    @initializeSearchView()

  initializeSearchView: ->
    @factRelationSearchView = new FactRelationSearchView
      factRelations: @collection
      type: @options.type

  highlightFactRelation: (view) ->
    $("ul.evidence-listing", @el).scrollTo view.el, 800
    view.highlight()

  addFactRelation: (factRelation, factRelations, options = {}) ->
    factRelationView = new FactRelationView(model: factRelation)
    @closeEmptyView()
    @_views.push factRelationView
    factRelationView.render()
    @$el.find("ul.evidence-listing").append factRelationView.el
    if options.highlight
      @highlightFactRelation factRelationView

  resetFactRelations: ->
    @collection.forEach (factRelation) =>
      @addFactRelation factRelation

    @showEmptyView() if @collection.length is 0

  onRender: -> @$el.prepend @factRelationSearchView.render().el

  hide: -> @$el.hide()
  show: -> @$el.show()

  showAndFetch: ->
    @fetch() unless @_fetched
    @show()

  fetch: ->
    @_fetched = true
    @collection.reset()
    @collection.fetch()


  showEmptyView: -> @$(".no-evidence-message").show()
  closeEmptyView: -> @$(".no-evidence-message").hide()
