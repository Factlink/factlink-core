# DEPRECATED (already), use DetachableViewsRegion

class Backbone.Factlink.DetachedViewPort extends Backbone.View
  constructor: (options) ->
    super(options)
    @_view = null

  currentView: -> @_view
  cleanup: -> @remove()
  close: -> @$el.detach()

  switchView: (new_view) ->
    return if new_view == @_view

    @$el.append(new_view.$el) if new_view?

    @_view.$el.detach() if @_view?

    @_view = new_view

  removeView: ->
    if @_view?
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

  clearUnshowedViews: ->
    for key, view of @cache
      if view != @_view
        @closeCacheView(key)

  cleanup: ->
    @removeView()
    @clearUnshowedViews()
    super()
