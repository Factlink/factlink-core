Backbone.Factlink ||= {}

class Backbone.Factlink.CrossFadeRegion extends Backbone.Marionette.Region

  defaultFadeTime = 560

  initialize: ->
    @_stateToken = 0
    @_fadeTime = @options?.fadeTime || defaultFadeTime

  crossFade: (newView) ->
    if @currentView
      @$el.fadeOut @_fadeTime, => @show newView
    else
      @show(newView)

  open: (view) ->
    @$el.hide()
    @$el.html view.el
    ++@_stateToken
    @$el.fadeIn @_fadeTime


  resetFade: ->
    return if !@$el #if there's no element, nothing's been shown.
    initialState = ++@_stateToken
    @$el.fadeOut @_fadeTime, => @reset() if initialState == @_stateToken


