class window.InteractiveTour
  helpTextDelay: 560

  bindLibraryLoad: ->
    $(window).on 'factlink.libraryLoaded', ->
      FACTLINK.hideDimmer()

      FACTLINK.on 'textSelected', ->
        tour.state.select_text()

      FACTLINK.on 'modalOpened', ->
        tour.state.open_modal()

      FACTLINK.on 'modalClosed', ->
        tour.state.close_modal()

      FACTLINK.on 'factlinkAdded', ->
        tour.state.create_factlink()

  constructor: ->
    @bindLibraryLoad()

    @state = StateMachine.create
      initial: 'started'
      events: [
        { name: 'select_text',     from: ['started',
                                          'text_selected'],                      to: 'text_selected' }
        { name: 'select_text',     from: ['factlink_created',
                                          'factlink_created_and_text_selected'], to: 'factlink_created_and_text_selected' }
        { name: 'open_modal',      from:  'text_selected',                       to: 'modal_opened' }
        { name: 'open_modal',      from:  'factlink_created_and_text_selected',  to: 'factlink_created_and_modal_opened' }
        { name: 'close_modal',     from:  'modal_opened',                        to: 'started' }
        { name: 'close_modal',     from:  'factlink_created_and_modal_opened',   to: 'started' }
        { name: 'create_factlink', from: ['modal_opened',
                                          'factlink_created_and_modal_opened'],  to: 'factlink_created' }
      ]
      callbacks:
        onstarted: =>
          @showHelpText(1)
        onleavestarted: =>
          @hideHelpText(=> @state.transition() if @state.transition)
          StateMachine.ASYNC
        ontext_selected: =>
          @showHelpText(2)
        onleavetext_selected: =>
          @hideHelpText(=> @state.transition() if @state.transition)
          StateMachine.ASYNC
        onfactlink_created: =>
          @showHelpText(3)
        onleavefactlink_created: =>
          @hideHelpText(=> @state.transition() if @state.transition)
          StateMachine.ASYNC

  hideHelpText: (callback) ->
    $('.help-text-container > div').fadeOut 'slow', callback
    StateMachine.ASYNC

  showHelpText: (current_step) ->
    setTimeout =>
      $("#step#{current_step}").fadeIn 'slow'
    , @helpTextDelay

if $('body').hasClass 'action_create_your_first_factlink'
  window.tour = new InteractiveTour()
