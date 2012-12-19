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
    if model.get('evidence_type') == 'FactRelation'
      FactRelationEvidenceView
    else if model.get('evidence_type') == 'Comment'
      CommentEvidenceView
    else
      console.info "This evidence type is not supported: #{model.get('evidence_type')}"

  itemViewFor: (item, itemView) ->
    if itemView == @emptyView
      itemView
    else
      @itemViewForModel(item)

  buildItemView: (item, itemView, options) ->
    super item, @itemViewFor(item, itemView), options


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
    @model.evidence()?.fetch()

  joinedSortedCollection: ->
    utils = new CollectionUtils(this)
    @_joinedCollection ?= @model.relations()

  onRender: ->
    @$el.addClass @model.type()

    @interactingUserRegion.show new InteractorsView
      collection: @model.getInteractors()

    if @model.relations()
      @factRelationSearchRegion.show new AddEvidenceView
        collection: @model.relations()
        model: @model
      @factRelationsRegion.show new EvidenceListView
        collection: @model.evidence()
        type: @model.evidence().type
        item_type: 'fact_relation'
    else
      @hideRegion @factRelationSearchRegion
      @hideRegion @factRelationsRegion

  hideRegion: (region)-> @$(region.el).hide()
