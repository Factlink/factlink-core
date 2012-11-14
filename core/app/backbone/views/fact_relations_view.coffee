class InteractorView extends Backbone.Marionette.ItemView
  tagName: 'span'
  template: "fact_relations/interactor"

class InteractorEmptyView extends Backbone.Marionette.ItemView
  template: "fact_relations/interactor_empty"

class InteractorsView extends Backbone.Marionette.CompositeView
  template: "fact_relations/interactors"
  emptyView : InteractorEmptyView
  itemView: InteractorView
  itemViewContainer: "span"

  initialize: (options) =>
    @type = @collection.type
    @collection.fetch()
    @numberNotDisplayed = @collection.total - @collection.length
    console.log(@numberNotDisplayed)
    console.log(@collection.total)
    console.log(@collection.length)

class EmptyFactRelationsView extends Backbone.Marionette.ItemView
  template: "fact_relations/_fact_relations_empty"
  className: "no-evidence-listing"
  tagName: 'li'
  templateHelpers: =>
    past_action: if (@options.type == 'weakening') then 'weakened' else 'supported'

class window.FactRelationsView extends Backbone.Marionette.CompositeView
  tagName: "div"
  className: "tab-content"
  template: "fact_relations/fact_relations"

  itemViewContainer: "ul.fact-relation-listing"

  itemView: FactRelationView
  itemViewOptions: => type: @type

  emptyView: EmptyFactRelationsView

  initialize: (options) ->
    @type = @collection.type
    @collection.bind 'add', this.potentialHighlight, this

    @initializeSearchView()
    @initializeInteractors()

  initializeSearchView: ->
    @factRelationSearchView = new FactRelationSearchView
      factRelations: @collection
      type: @type

  initializeInteractors: ->
    switch @type
      when 'supporting'
        interactorsCollection = new FactBelieversPage
          fact: @model
      when 'weakening'
        interactorsCollection = new FactDoubtersPage
          fact: @model
      when 'doubting'
        interactorsCollection = new FactDisbelieversPage
          fact: @model

    @interactorsView = new InteractorsView
      collection: interactorsCollection

  highlightFactRelation: (model) ->
    view = @children[model.cid]
    @$(this.itemViewContainer).scrollTo view.el, 800
    view.highlight()

  addChildView: (item, collection, options) ->
    res = super(item, collection, options)
    @highlightFactRelation(item) if options.highlight
    return res

  onRender: ->
    @$el.addClass(@type)
    @$('.fact-relation-search').append @factRelationSearchView.render().el
    @$('.interacting-users').append @interactorsView.render().el

  fetch: ->
    unless @_fetched
      @_fetched = true
      @collection.reset()
      @collection.fetch()
