Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  defaultFadeTime = 560

  crossFade: (newView) ->
    if @currentView
      @$el.stop().fadeOut(@_fadeTime(), => @show newView)
    else
      @show(newView)

  open: (view) ->
    @$el.stop().hide()
        .html(view.el)
        .fadeIn(@_fadeTime())

  resetFade: ->
    return unless @$el #if there's no element, nothing's been shown.
    @$el.stop().fadeOut(@_fadeTime(), => @reset())

  _fadeTime: -> @options?.fadeTime || defaultFadeTime

