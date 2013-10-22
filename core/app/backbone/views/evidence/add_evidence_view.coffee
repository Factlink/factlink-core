class window.AddEvidenceView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'evidence-add'

  template: 'evidence/add_evidence'

  ui:
    box: '.js-add-box'
    buttons: '.js-add-buttons'

  events:
    'click .js-cancel': -> @model.set showBox: false
    'click .js-supporting-button': -> @model.set showBox: true, evidenceType: 'supporting'
    'click .js-weakening-button': -> @model.set showBox: true, evidenceType: 'weakening'

  regions:
    headingRegion: '.js-heading-region'
    contentRegion: '.js-content-region'

  collectionEvents:
    'request sync': '_updateElementVisiblity'
    'start_adding_model': -> @model.set saving: true
    'error_adding_model': -> @model.set saving: false
    'saved_added_model': -> @model.set showBox: false, saving: false

  initialize: ->
    @model = new Backbone.Model saving: false, showBox: false
    @listenTo @model, 'change:saving', @_updateElementVisiblity
    @listenTo @model, 'change:showBox', @_updateBox

  onRender: ->
    @_updateElementVisiblity()
    @_updateBox()

  _updateElementVisiblity: ->
    @$el.toggle !@collection.loading() && !@model.get('saving')
    @_updatePopovers()

  _updateBox: ->
    if @model.get('showBox')
      @ui.buttons.hide()

      @ui.box.show()
      @ui.box.removeClass 'evidence-weakening evidence-supporting'
      @ui.box.addClass 'evidence-' + @model.get('evidenceType')

      @headingRegion.show new EvidenceishHeadingView model: currentUser
      @contentRegion.show new AddEvidenceFormView
        collection: @collection.oneSidedEvidenceCollection @model.get('evidenceType')
        fact_id: @options.fact_id
        type: @model.get('evidenceType')
    else
      @ui.box.hide()
      @ui.buttons.show()
      @_updatePopovers()

  _updatePopovers: ->
    return if @_popoversRendered
    return unless @$el.is(':visible')
    return if @model.get('showBox')

    @popoverAdd '.js-supporting-button',
      side: 'right'
      margin: 10
      container: @ui.buttons
      contentView: new TextView text: 'Add supporting argument'
      popover_className: 'translucent-popover translucent-grey-popover'

    @popoverAdd '.js-weakening-button',
      side: 'left'
      margin: 10
      container: @ui.buttons
      contentView: new TextView text: 'Add weakening argument'
      popover_className: 'translucent-popover translucent-grey-popover'

    @_popoversRendered = true
