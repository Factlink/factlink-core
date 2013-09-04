class AddEvidenceButtonsView extends Backbone.Marionette.Layout
  className: 'evidence-add-buttons'
  template: 'evidence/add_evidence_buttons'

  events:
    'click .js-supporting-button': -> @options.parentView.showAdd 'supporting'
    'click .js-weakening-button': -> @options.parentView.showAdd 'weakening'

  onRender: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'right'
        popover_className: 'translucent-dark-popover'
      selector: '.js-supporting-button'
      tooltipViewFactory: => new TextView
        model: new Backbone.Model
          text: 'Add supporting argument'
    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'left'
        popover_className: 'translucent-dark-popover'
      selector: '.js-weakening-button'
      tooltipViewFactory: => new TextView
        model: new Backbone.Model
          text: 'Add weakening argument'


class window.AddEvidenceView extends Backbone.Marionette.Layout
  className: 'evidence-add'

  template: 'evidence/ndp_add_evidence'

  ui:
    box: '.js-box'

  events:
    'click .js-cancel': 'cancel'

  regions:
    buttonsRegion: '.js-buttons-region'
    headingRegion: '.js-heading-region'
    contentRegion: '.js-content-region'

  collectionEvents:
    'saved_added_model': 'cancel'

  onRender: ->
    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @cancel()

  showAddSupporting: -> @_showAdd 'supporting'
  showAddWeakening:  -> @_showAdd 'weakening'

  cancel: ->
    @ui.box.hide()
    @buttonsRegion.show new AddEvidenceButtonsView
      parentView: this

  showAdd: (type) ->
    @buttonsRegion.close()
    @ui.box.show()
    @ui.box.removeClass 'evidence-weakening evidence-supporting'
    @ui.box.addClass 'evidence-' + type

    @contentRegion.close()
    @contentRegion.show new AddEvidenceFormView
      collection: @collection.oneSidedEvidenceCollection(type)
      fact_id: @options.fact_id
      type: type
