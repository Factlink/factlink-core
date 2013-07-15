Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  crossFade: (newView) ->
    if @currentView
      @$el.stop().fadeOut(@_fadeTime(), => @show newView)
    else
      @show(newView)

  open: (view) -> @$el.stop().hide().html(view.el).fadeIn(@_fadeTime())

  resetFade: -> @$el?.stop().fadeOut(@_fadeTime(), => @reset())

  _fadeTime: ->
    if @options?.fadeTime?
      @options.fadeTime
    else
      560

  onClose: -> @$el?.stop()
