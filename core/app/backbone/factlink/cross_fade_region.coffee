Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  fadeOut: (callback) -> @$el?.stop().fadeOut(@_fadeTime())

  crossFade: (newView) ->
    if @currentView
      @fadeOut => @show newView
    else
      @show(newView)

  open: (view) -> @$el.stop().hide().html(view.el).fadeIn(@_fadeTime())

  resetFade: -> @fadeOut => @reset()

  _fadeTime: ->
    if @options?.fadeTime?
      @options.fadeTime
    else
      560

  onClose: -> @$el?.stop()
