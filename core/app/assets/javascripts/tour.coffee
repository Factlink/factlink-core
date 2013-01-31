class window.InteractiveTour
  helpTextDelay: 560

  bindLibraryLoad: ->
    $(window).on 'factlink.libraryLoaded', ->
      FACTLINK.hideDimmer()

      $('#create-your-first-factlink').on 'mouseup', ->
        if FACTLINK.getSelectionInfo().text.length > 0
          tour.state.select_text()
        else
          tour.state.deselect_text()

      FACTLINK.on 'modalOpened', ->
        tour.state.open_modal()

      FACTLINK.on 'modalClosed', ->
        tour.state.close_modal()

      FACTLINK.on 'factlinkAdded', ->
        tour.state.create_factlink()

  renderExtensionButton: ->
    @extensionButton = new ExtensionButtonMimic()
    $('.js-extension-button-region').append(@extensionButton.render().el)

  constructor: ->
    @renderExtensionButton()

    @bindLibraryLoad()

    @state = StateMachine.create
      initial: 'started'
      events: [
        { name: 'select_text',     from: ['started',
                                          'text_selected'],                      to: 'text_selected' }
        { name: 'select_text',     from: ['factlink_created',
                                          'factlink_created_and_text_selected'], to: 'factlink_created_and_text_selected' }
        { name: 'deselect_text',   from:  'started',                             to: 'started' }
        { name: 'deselect_text',   from:  'factlink_created',                    to: 'factlink_created' }
        { name: 'deselect_text',   from:  'text_selected',                       to: 'started' }
        { name: 'deselect_text',   from:  'factlink_created_and_text_selected',  to: 'factlink_created' }
        { name: 'open_modal',      from:  'text_selected',                       to: 'modal_opened' }
        { name: 'open_modal',      from:  ['factlink_created',
                                           'factlink_created_and_text_selected'],to: 'factlink_created_and_modal_opened' }
        { name: 'close_modal',     from:  'modal_opened',                        to: 'started' }
        { name: 'close_modal',     from:  'factlink_created_and_modal_opened',   to: 'factlink_created' }
        { name: 'create_factlink', from: ['modal_opened',
                                          'factlink_created_and_modal_opened'],  to: 'factlink_created' }
      ]
      callbacks:
        onstarted: =>
          @showHelpText(1)
        onleavestarted: =>
          @hideHelpText(1)
          StateMachine.ASYNC
        ontext_selected: =>
          @showHelpText(2)
        onleavetext_selected: =>
          @hideHelpText(2)
          StateMachine.ASYNC
        onfactlink_created: =>
          @extensionButton.increaseCount()
          @showHelpText(3)
        onleavefactlink_created: =>
          @hideHelpText(3)
          StateMachine.ASYNC

  hideHelpText: (step) ->
    $("#step#{step}").fadeOut 'fast', =>
      @state.transition()

    StateMachine.ASYNC

  showHelpText: (current_step) ->
    setTimeout =>
      $("#step#{current_step}").fadeIn 'fast'
    , @helpTextDelay

$ ->
  if $('body').hasClass 'action_create_your_first_factlink'
    window.tour = new InteractiveTour()
