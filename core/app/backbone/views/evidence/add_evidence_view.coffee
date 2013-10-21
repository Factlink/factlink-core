class window.AddEvidenceView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'evidence-add'

  template: 'evidence/add_evidence'

  ui:
    box: '.js-box'
    buttons: '.js-buttons'

  events:
    'click .js-cancel': 'cancel'
    'click .js-supporting-button': -> @_showAdd 'supporting'
    'click .js-weakening-button': -> @_showAdd 'weakening'

  regions:
    headingRegion: '.js-heading-region'
    contentRegion: '.js-content-region'

  collectionEvents:
    'saved_added_model': 'cancel'
    'error_adding_model': 'showBox'
    'add': 'hideBox'
    'request sync': '_updateLoading'

  onRender: ->
    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @cancel()
    @_updateLoading()

  cancel: ->
    @hideBox()
    @ui.buttons.show()

  showBox: -> @ui.box.show()
  hideBox: -> @ui.box.hide()

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

  _updateLoading: ->
    @$el.toggle !@collection.loading()
    @_renderPopovers() unless @collection.loading()

  _renderPopovers: ->
    @popoverResetAll()

    @popoverAdd '.js-supporting-button',
      side: 'right'
      margin: 10
      container: @ui.buttons
      contentView: new TextView
        model: new Backbone.Model
          text: 'Add supporting argument'
      popover_className: 'translucent-popover translucent-grey-popover'

    @popoverAdd '.js-weakening-button',
      side: 'left'
      margin: 10
      container: @ui.buttons
      contentView: new TextView
        model: new Backbone.Model
          text: 'Add weakening argument'
      popover_className: 'translucent-popover translucent-grey-popover'

