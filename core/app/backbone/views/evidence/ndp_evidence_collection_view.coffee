class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/ndp_evidence_layout'

  regions:
    contentRegion: '.js-content-region'

  typeCss: ->
    switch @model.get('type')
      when 'believes' then 'evidence-supporting'
      when 'disbelieves' then 'evidence-weakening'
      when 'doubts' then 'evidence-unsure'

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @$el.addClass @typeCss()

    if @model instanceof OpinionatersEvidence
      @contentRegion.show new InteractingUsersView model: @model
    else
      @contentRegion.show new TextView model: new Backbone.Model text: @model.id

class NDPEvidenceLoadingView extends Backbone.Marionette.ItemView
  className: "evidence-loading"
  template: 'evidence/ndp_evidence_loading_indicator'

class NDPEvidenceEmptyLoadingView extends Backbone.Factlink.EmptyLoadingView
  loadingView: NDPEvidenceLoadingView

class window.NDPEvidenceCollectionView extends Backbone.Marionette.CompositeView
  className: 'evidence-collection'
  template: 'evidence/ndp_evidence_collection'
  itemView: NDPEvidenceLayoutView
  itemViewContainer: '.js-evidence-item-view-container'
  emptyView: NDPEvidenceEmptyLoadingView


  itemViewOptions: ->
    collection: @collection

  initialize: ->
    @bindTo @collection, 'change:impact sync', @render
