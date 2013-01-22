class window.InteractiveTour
  helpTextDelay: 560

  constructor: ->
    @initializeTour()

  initializeTour: ->
    @lastStep = 0
    @currentStep = 0
    @factlinkAdded = false

    @showStep(1)

  resetIfNoFactlinkAdded: ->
    unless @factlinkAdded
      @initializeTour()

  showStep: (id) ->
    @lastStep = @currentStep
    @currentStep = id

    if ( @lastStep != @currentStep ) and ( @lastStep < @currentStep )
      @showHelpText(id)

  hide: (callback) ->
    $('.help-text-container > div').fadeOut 'slow', callback

  showHelpText: ->
    @hide =>
      setTimeout =>
        $("#step#{@currentStep}").fadeIn 'slow'
      , @helpTextDelay

window.tour = new InteractiveTour
