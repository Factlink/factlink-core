Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  defaultFadeTime = 560

  crossFade: (newView) ->
    if @currentView
      @$el.stop()
      @$el.fadeOut @_fadeTime(), => @show newView
    else
      @show(newView)

  open: (view) ->
    @$el.stop()
    @$el.hide()
    @$el.html view.el
    @$el.fadeIn @_fadeTime()

  resetFade: ->
    return unless @$el #if there's no element, nothing's been shown.
    @$el.stop()
    @$el.fadeOut @_fadeTime(), => @reset()

  _fadeTime: -> @options?.fadeTime || defaultFadeTime

