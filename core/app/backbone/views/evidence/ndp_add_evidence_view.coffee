class window.NDPAddEvidenceView extends Backbone.Marionette.ItemView
  className: 'evidence-add'

  template: 'evidence/ndp_add_evidence'

  ui:
    buttons: '.js-buttons'
    box: '.js-box'

  events:
    'click .js-supporting-button': 'showAddSupporting'
    'click .js-weakening-button': 'showAddWeakening'
    'click .js-cancel': 'cancel'

  onRender: ->
    @cancel()

  showAddSupporting: -> @_showAdd true
  showAddWeakening:  -> @_showAdd false

  cancel: ->
    @ui.box.hide()
    @ui.buttons.show()

  _showAdd: (supporting) ->
    @ui.buttons.hide()
    @ui.box.show()
    @ui.box.toggleClass 'evidence-weakening', !supporting
    @ui.box.toggleClass 'evidence-supporting', !!supporting
