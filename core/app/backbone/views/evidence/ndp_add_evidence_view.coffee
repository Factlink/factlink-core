class window.NDPAddEvidenceView extends Backbone.Marionette.Layout
  className: 'evidence-add'

  template: 'evidence/ndp_add_evidence'

  ui:
    buttons: '.js-buttons'
    box: '.js-box'

  events:
    'click .js-supporting-button': 'showAddSupporting'
    'click .js-weakening-button': 'showAddWeakening'
    'click .js-cancel': 'cancel'

  regions:
    headingRegion: '.js-heading-region'
    contentRegion: '.js-content-region'

  collectionEvents:
    'saved_added_model': 'cancel'

  onRender: ->
    @headingRegion.show new NDPEvidenceishHeadingView model: currentUser
    @cancel()
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


  showAddSupporting: -> @_showAdd 'supporting'
  showAddWeakening:  -> @_showAdd 'weakening'

  cancel: ->
    @ui.box.hide()
    @ui.buttons.show()

  _showAdd: (type) ->
    @ui.buttons.hide()
    @ui.box.show()
    @ui.box.removeClass 'evidence-weakening evidence-supporting'
    @ui.box.addClass 'evidence-' + type

    @contentRegion.close()
    @contentRegion.show new AddEvidenceFormView
      collection: @collection.oneSidedEvidenceCollection(type)
      fact_id: @options.fact_id
      type: type
      ndp: true
