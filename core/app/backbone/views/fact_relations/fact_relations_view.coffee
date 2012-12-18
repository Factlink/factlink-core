#= require ../interactors_view

class EmptyEvidenceView extends Backbone.Marionette.ItemView
  template: "fact_relations/_fact_relations_empty"
  className: "no-evidence-listing"
  tagName: 'li'

  templateHelpers: =>
    past_action:
      switch @options.type
        when 'weakening' then 'weakened'
        when 'supporting' then 'supported'

class EvidenceListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'fact-relation-listing'

  itemView: Backbone.View
  itemViewOptions: => type: @options.type
  emptyView: EmptyEvidenceView

  addChildView: (item, collection, options) ->
    result = super(item, collection, options)
    @highlightFactRelation(item) if options.highlight
    result

  highlightFactRelation: (model) ->
    view = @children[model.cid]
    @$el.scrollTo view.el, 800
    view.highlight()

  itemViewForModel: (model) ->
    if model.get('fact_relation_type')?
      FactRelationEvidenceView
    else
      CommentEvidenceView

  itemViewFor: (item, itemView) ->
    if itemView == @emptyView
      itemView
    else
      @itemViewForModel(item)

  buildItemView: (item, itemView) ->
    super item, @itemViewFor(item, itemView)

class window.FactRelationsView extends Backbone.Marionette.Layout
  className: "tab-content"
  template: "fact_relations/fact_relations"

  regions:
    interactingUserRegion: '.interacting-users'
    factRelationsRegion: '.fact-relation-listing-container'
    factRelationSearchRegion: '.fact-relation-search'
    commentsRegion: '.comments-listing-region'

  initialize: ->
    @model.relations()?.fetch()
    @model.comments()?.fetch()

  joinedSortedCollection: ->
    utils = new CollectionUtils(this)
    @_joinedCollection ?= utils.union new EvidenceCollection, @model.relations(), @model.comments()

  onRender: ->
    @$el.addClass @model.type()

    @interactingUserRegion.show new InteractorsView
      collection: @model.getInteractors()

    if @model.relations()
      @factRelationSearchRegion.show new AddEvidenceView
        collection: @model.relations()
        model: @model
      @factRelationsRegion.show new EvidenceListView
        collection: @joinedSortedCollection()
        type: @model.relations().type
        item_type: 'fact_relation'
    else
      @hideRegion @factRelationSearchRegion
      @hideRegion @factRelationsRegion

  hideRegion: (region)-> @$(region.el).hide()
