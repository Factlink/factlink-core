class NDPEvidenceLayoutView extends Backbone.Marionette.Layout
  template: 'evidence/ndp_evidence_layout'

  regions:
    contentRegion: '.js-content-region'

  templateHelpers:
    formatted_impact: -> format_as_authority @impact

  typeCss: ->
    switch @model.get('type')
      when 'believe' then 'evidence-supporting'
      when 'disbelieve' then 'evidence-weakening'
      when 'doubt' then 'evidence-unsure'

  shouldShow: -> @model.has('impact') && @model.get('impact') > 0.0

  onRender: ->
    @$el.toggle @shouldShow()
    @contentRegion.show new InteractingUsersView model: @model
    @$el.addClass @typeCss()

class NDPEvidenceLoadingView extends Backbone.Marionette.ItemView
  className: "evidence-loading"
  template: text: '''
    <div class="evidence-impact">
      <div class="new-design-background-shadow"></div>
      <img class="ajax-loader" src="{{global.ajax_loader_image}}">
    </div>
    '''


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
    @bindTo @collection, 'change:impact', @render
