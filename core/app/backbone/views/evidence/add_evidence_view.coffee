class window.AddEvidenceView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'evidence-add'

  template: 'evidence/add_evidence'

  ui:
    box: '.js-add-box'
    buttons: '.js-add-buttons'

  events:
    'click .js-cancel': -> @model.set 'boxType', 'buttons'
    'click .js-supporting-button': -> @model.set 'boxType', 'supporting'
    'click .js-weakening-button': -> @model.set 'boxType', 'weakening'

  regions:
    headingRegion: '.js-heading-region'
    contentRegion: '.js-content-region'

  collectionEvents:
    'saved_added_model': -> @model.set 'boxType', 'buttons'
    'error_adding_model': -> @model.set 'saving', false
    'add': -> @model.set 'saving', true
    'request sync': '_update'

  initialize: ->
    @model = new Backbone.Model saving: false, boxType: 'buttons'
    @listenTo @model, 'change', @_update

  onRender: -> @_update()

  _update: ->
    @$el.toggle !@collection.loading()

    @ui.buttons.toggle @model.get('boxType') == 'buttons'
    @ui.box.toggle @model.get('boxType') != 'buttons'
    @_updateBox()
    @_updatePopovers()

  _updateBox: ->
    return if @model.get('boxType') == 'buttons'
    return if @boxType == @model.get('boxType')

    @boxType = @model.get('boxType')

    @ui.box.removeClass 'evidence-weakening evidence-supporting'
    @ui.box.addClass 'evidence-' + @model.get('boxType')

    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @contentRegion.show new AddEvidenceFormView
      collection: @collection.oneSidedEvidenceCollection @model.get('boxType')
      fact_id: @options.fact_id
      type: @model.get('boxType')

  _updatePopovers: ->
    return if @collection.loading()
    return unless @model.get('boxType') == 'buttons'
    return if @_popoversRendered

    @_popoversRendered = true

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
