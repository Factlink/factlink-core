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
  className: "tab-content"
  template: "fact_relations/fact_relations"

  itemViewContainer: ".fact-relation-listing"

  itemView: FactRelationView
  itemViewOptions: => type: @model.type()

  emptyView: EmptyFactRelationsView

  initialize: (options) ->
    @bindTo @model.relations(), 'add',
           this.potentialHighlight, this

    @model.relations().fetch()
    @collection = @model.relations()
    @initializeSearchView()
    @initializeInteractors()

  initializeSearchView: ->
    @factRelationSearchView = new FactRelationSearchView
      factRelations: @model.relations()

  initializeInteractors: ->
    interactorsCollection = switch @model.type()
      when 'supporting'
        new FactBelieversPage fact: @model.fact()
      when 'weakening'
        new FactDisbelieversPage fact: @model.fact()

    @interactorsView = new window.InteractorsView
      collection: interactorsCollection

  highlightFactRelation: (model) ->
    view = @children[model.cid]
    @$(this.itemViewContainer).scrollTo view.el, 800
    view.highlight()

  addChildView: (item, collection, options) ->
    res = super(item, collection, options)
    @highlightFactRelation(item) if options.highlight
    res

  onRender: ->
    @$el.addClass @model.type()
    @$('.interacting-users').append @interactorsView.render().el
    @$('.fact-relation-search').append @factRelationSearchView.render().el

class window.DoubtingRelationsView extends Backbone.Marionette.Layout
  className: "tab-content"
  template: "fact_relations/doubting_fact_relations"

  initialize: (options) ->
    @initializeInteractors()

  initializeInteractors: ->
    interactorsCollection = new FactDoubtersPage
      fact: @model.fact()

    @interactorsView = new InteractorsView
      collection: interactorsCollection

  onRender: ->
    @$el.addClass @model.type()
    @$('.interacting-users').append @interactorsView.render().el
