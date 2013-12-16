class FirstFactlinkFactView extends Backbone.Marionette.ItemView
  templateHelpers: ->
    next_tourstep_path: window.next_tourstep_path
  template: 'tour/first_factlink_fact'

class window.InteractiveTour extends Backbone.View
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  helpTextDelay: 560

  # TODO: create events in the js-library for this
  detectSelecting: ->
    if @_getTextRange().length > 0
      @state.select_text()

  detectDeselecting: ->
    if @_getTextRange().length <= 0
      @state.deselect_text()

  bindSelectionEvents: ->
    @detectDeselectingInterval = window.setInterval (=> @detectDeselecting()), 200 unless @detectDeselectingInterval?

    $('.create-your-first-factlink-content').on 'mouseup', =>
      @detectSelecting()
      @detectDeselecting()

  bindJsLibraryEvents: ->
    return unless FACTLINK? # On the CI there is no js-library, so we just skip this

    FACTLINK.on 'factlinkAdded', =>
      @state.create_factlink()

  renderExtensionButton: ->
    @extensionButton = new ExtensionButtonMimic()
    $('.js-extension-button-region').append(@extensionButton.render().el)

  initialize: ->
    @isClosed = false # Hack to fake Marionette behaviour. Used in PopoverMixin.

    @renderExtensionButton()

    @bindSelectionEvents()
    @bindJsLibraryEvents()

    @createStateMachine()

  close: ->
    window.clearInterval @detectDeselectingInterval

  createStateMachine: ->
    @state = StateMachine.create
      initial: 'started'
      events: [
        { name: 'select_text',     from: ['started',
                                          'text_selected'],     to: 'text_selected' }
        { name: 'select_text',     from:  'factlink_created',   to: 'factlink_created' }
        { name: 'deselect_text',   from:  'started',            to: 'started' }
        { name: 'deselect_text',   from:  'text_selected',      to: 'started' }
        { name: 'deselect_text',   from:  'factlink_created',   to: 'factlink_created' }
        { name: 'create_factlink', from:  ['started',
                                           'text_selected',
                                           'factlink_created'], to: 'factlink_created' }
      ]
      callbacks:
        onstarted: =>
          @popoverAdd '.create-your-first-factlink-content > p:first',
            side: 'left'
            align: 'top'
            contentView: new Backbone.Marionette.ItemView(template: 'tour/lets_create')

        onleavestarted: =>
          @popoverRemove '.create-your-first-factlink-content > p:first'
          @state.transition()

        ontext_selected: =>
          @popoverAdd '#extension-button',
            side: 'left'
            align: 'top'
            alignMargin: 60
            contentView: new Backbone.Marionette.ItemView(template: 'tour/extension_button')

          mp_track "Tour: Selected text"

        onleavetext_selected: =>
          @popoverRemove '#extension-button',
          @state.transition()

        onfactlink_created: =>
          @extensionButton.increaseCount()

          Backbone.Factlink.asyncChecking @factlinkFirstExists, @addFactlinkFirstTooltip, @

  factlinkFirstExists: ->
    @$('.factlink.fl-first').length > 0

  addFactlinkFirstTooltip: ->
    @popoverAdd '.factlink.fl-first',
      side: 'left'
      align: 'top'
      margin: 10
      contentView: new FirstFactlinkFactView

  _getTextRange: ->
    doc = window.document
    if doc.getSelection
      doc.getSelection().toString()
    else if doc.selection
      doc.selection.createRange().text.toString()
    else
      ''
