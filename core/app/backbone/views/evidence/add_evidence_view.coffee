class window.AddEvidenceView extends Backbone.Marionette.Layout
  className: 'evidence-add'

  template: 'evidence/add_evidence'

  ui:
    box: '.js-add-box'
    buttons: '.js-add-buttons'

  events:
    'click .js-cancel': -> @model.set showBox: false

    'click .js-believes-button': ->
      @model.set
        showBox: true
        evidenceBelieveType: 'believes'

    'click .js-disbelieves-button': ->
      @model.set
        showBox: true
        evidenceBelieveType: 'disbelieves'

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
    @listenTo @model, 'change:showBox', @_updateInterface

  onRender: ->
    @_updateElementVisiblity()
    @_updateInterface()

  _updateElementVisiblity: ->
    @$el.toggle !@collection.loading() && !@model.get('saving')

  _updateInterface: ->
    if @model.get('showBox')
      @ui.buttons.hide()

      @ui.box.show()
      @ui.box.removeClass 'evidence-disbelieves evidence-believes evidence-unsure'
      @ui.box.addClass 'evidence-' + @model.get('evidenceBelieveType')

      @headingRegion.show new EvidenceishHeadingView model: currentUser

      @contentRegion.show new AddEvidenceFormView
        collection: @collection.realEvidenceCollection
        fact_id: @options.fact_id
        type: @model.get('evidenceBelieveType')
    else
      @ui.box.hide()
      @ui.buttons.show()
