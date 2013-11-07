Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  fadeIn: ->
    @$el.stop().hide().fadeIn(@_fadeTime())

  fadeOut: (callback) ->
    @ensureEl()
    @$el.stop().fadeOut(@_fadeTime(), callback)

  crossFade: (newView) ->
    if @currentView
      @fadeOut => @show newView
    else
      @show(newView)

  open: (view) ->
    super(view)
    @fadeIn()

  resetFade: -> @fadeOut => @reset()

  _fadeTime: ->
    if @options?.fadeTime?
      @options.fadeTime
    else
      560

  onClose: -> @$el?.stop()
