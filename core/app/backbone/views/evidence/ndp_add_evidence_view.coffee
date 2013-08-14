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

  onRender: ->
    @headingRegion.show new NDPEvidenceishHeadingView model: currentUser
    @cancel()

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
