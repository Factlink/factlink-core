#= require ./interactors_view

class EmptyFactRelationsView extends Backbone.Marionette.ItemView
  template: "fact_relations/_fact_relations_empty"
  className: "no-evidence-listing"
  tagName: 'li'

  templateHelpers: =>
    past_action:
      switch @options.type
        when 'weakening' then 'weakened'
        when 'supporting' then 'supported'
        when 'doubting' then 'doubted'

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
        interactorsCollection = new FactDisbelieversPage
          fact: @model
      when 'doubting'
        interactorsCollection = new FactDoubtersPage
          fact: @model

    @interactorsView = new window.InteractorsView
      collection: interactorsCollection
      type: @type

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

class window.DoubtingRelationsView extends Backbone.Marionette.Layout
  tagName: "div"
  className: "tab-content"
  template: "fact_relations/doubting_fact_relations"

  initialize: (options) ->
    console.info('call')
    @type = options.type
    @initializeInteractors()

  initializeInteractors: ->
    switch @type
      when 'supporting'
        interactorsCollection = new FactBelieversPage
          fact: @model
      when 'weakening'
        interactorsCollection = new FactDisbelieversPage
          fact: @model
      when 'doubting'
        interactorsCollection = new FactDoubtersPage
          fact: @model

    @interactorsView = new InteractorsView
      collection: interactorsCollection
      type: @type

  onRender: ->
    @$el.addClass(@type)
    @$('.interacting-users').append @interactorsView.render().el
