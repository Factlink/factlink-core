Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  defaultFadeTime: 560

  crossFade: (newView) ->
    currentView = @currentView

    if currentView
      @$el.fadeOut @fadeTime(), (=> @show newView)
    else
      @show(newView)

  open: (view) ->
    @$el.hide();
    @$el.html view.el
    @$el.fadeIn @fadeTime()

  resetFade: ->
    @$el.fadeOut @fadeTime(), (=> @reset())

  fadeTime: ->
    @options?.fadeTime || @defaultFadeTime
