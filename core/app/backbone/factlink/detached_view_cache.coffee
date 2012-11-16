class Backbone.Factlink.DetachedViewPort extends Backbone.View
  constructor: (options) ->
    super(options)
    @_view = null
    @_transition = options?.transition

  currentView: -> @_view
  cleanup: -> @remove()
  close: -> @$el.detach()

  switchView: (new_view) ->
    return if new_view == @_view

    @$el.append(new_view.$el)

    if @_view?
      @transitionView(new_view, @_view)

    @_view = new_view

  transitionView: (new_view, old_view) ->
    if @_transition?
      @_transition.run old_view.$el, new_view.$el, ->
        old_view.$el.detach()
    else
      old_view.$el.detach()

  removeView: ->
      @_view.$el.detach()
      @_view = null



class Backbone.Factlink.DetachedViewCache extends Backbone.Factlink.DetachedViewPort
  initialize: ->
    @cache = {}
    @current = null

  switchCacheView: (key) ->
    view = @cache[key] || null
    @switchView(view) if view?
    view

  renderCacheView: (key, view) ->
    @current = @cache[key] = view
    @current.render()
    @switchView(@current)

  closeCacheView: (key) ->
    @cache[key].close() if @cache[key].close?
    @cache[key].remove()
    delete @cache[key]

  clear: ->
    for key, view of @cache
      if view != @_view
        @closeCacheView(key)

  cleanup: ->
    @_view = null
    @clear()
    super()
