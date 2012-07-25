window.FactRelationsView = Backbone.Factlink.PlainView.extend(
  tagName: "div"
  className: "page evidence-list fact-relations-container"
  template: "fact_relations/fact_relations"
  initialize: (options) ->
    @_views = []
    @_loading = true
    @collection.bind "add", @addFactRelation, this
    @collection.bind "remove", @removeFactRelation, this
    @collection.bind "reset", @resetFactRelations, this
    @showEmptyView()
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

  removeFactRelation: (factRelation) ->
    console.info "Removing one FactRelation"

  onRender: -> @$el.prepend @factRelationSearchView.render().el

  hide: -> @$el.hide()
  show: -> @$el.show()

  showAndFetch: ->
    unless @_fetched
      @_fetched = true
      @collection.reset()
      @showLoadingIndicator()
      @collection.fetch success: => @hideLoadingIndicator()
    @show()

  showLoadingIndicator: ->
    @$(".loading-evidence").show()
    @closeEmptyView()

  hideLoadingIndicator: -> @$(".loading-evidence").hide()

  showEmptyView: ->
    @$(".no-evidence-message").show()
    @hideLoadingIndicator()

  closeEmptyView: -> @$(".no-evidence-message").hide()
)
