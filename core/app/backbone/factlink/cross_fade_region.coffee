Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  defaultFadeTime = 560

  initialize: -> @on 'close', -> @$el?.stop()

  crossFade: (newView) ->
    if @currentView
      @$el.stop().fadeOut(@_fadeTime(), => @show newView)
    else
      @show(newView)

  open: (view) ->
    @$el.stop().hide().html(view.el)
        .fadeIn(@_fadeTime())

  resetFade: -> @$el?.stop().fadeOut(@_fadeTime(), => @reset())

  _fadeTime: -> @options?.fadeTime || defaultFadeTime

