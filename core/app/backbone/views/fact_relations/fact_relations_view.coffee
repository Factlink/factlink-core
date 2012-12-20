#= require ../interactors_view

class EmptyFactRelationsView extends Backbone.Marionette.ItemView
  template: "fact_relations/_fact_relations_empty"
  className: "no-evidence-listing"
  tagName: 'li'

  templateHelpers: =>
    past_action:
      switch @options.type
        when 'weakening' then 'weakened'
        when 'supporting' then 'supported'

class FactRelationsListView extends Backbone.Marionette.CollectionView
  tagName: 'ul'
  className: 'fact-relation-listing'

  itemView: FactRelationEvidenceView
  itemViewOptions: => type: @collection.type
  emptyView: EmptyFactRelationsView

  addChildView: (item, collection, options) ->
    result = super(item, collection, options)
    @highlightFactRelation(item) if options.highlight
    result

  highlightFactRelation: (model) ->
    view = @children.findByModel(model)
    @$el.scrollTo view.el, 800
    view.highlight()

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

  onRender: ->
    @$el.addClass @model.type()

    @interactingUserRegion.show new InteractorsView
      collection: @model.getInteractors()

    @commentsRegion.show new CommentsListView
      collection: @model.comments()

    if @model.relations()
      @factRelationSearchRegion.show new AddEvidenceView
        collection: @model.relations()
        model: @model
      @factRelationsRegion.show new FactRelationsListView
        collection: @model.relations()
    else
      @hideRegion @factRelationSearchRegion
      @hideRegion @factRelationsRegion

  hideRegion: (region)-> @$(region.el).hide()
