class AddEvidenceButtonsView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  className: 'evidence-add-buttons'
  template: 'evidence/add_evidence_buttons'

  events:
    'click .js-supporting-button': -> @options.parentView.showAdd 'supporting'
    'click .js-weakening-button': -> @options.parentView.showAdd 'weakening'

  onRender: ->
    @popoverAdd '.js-supporting-button',
      side: 'right'
      margin: 10
      contentView: new TextView
        model: new Backbone.Model
          text: 'Add supporting argument'
      popover_className: 'translucent-dark-popover'

    @popoverAdd '.js-weakening-button',
      side: 'left'
      margin: 10
      contentView: new TextView
        model: new Backbone.Model
          text: 'Add weakening argument'
      popover_className: 'translucent-dark-popover'


class window.AddEvidenceView extends Backbone.Marionette.Layout
  className: 'evidence-add'

  template: 'evidence/add_evidence'

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
    'error_adding_model': 'showBox'
    'add': 'hideBox'

  onRender: ->
    @headingRegion.show new EvidenceishHeadingView model: currentUser
    @cancel()

  cancel: ->
    @hideBox()
    @buttonsRegion.show new AddEvidenceButtonsView
      parentView: this

  showBox: -> @ui.box.show()
  hideBox: -> @ui.box.hide()

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
