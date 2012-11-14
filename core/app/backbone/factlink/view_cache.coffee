class Backbone.Factlink.DetachedViewContainer extends Backbone.View
  constructor: (options) ->
    super(options)
    @_view = null
    @_transition = options?.transition

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

  close: ->
    @$el.detach()

  cleanup: ->
    @remove()

class Backbone.Factlink.DetachedViewCache extends Backbone.Factlink.DetachedViewContainer
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
    @views[key].close()
    @views[key] = undefined

  clear: ->
    for key, view of @views
      @closeView(key)
      view.remove()

  cleanup: ->
    @clear()
    super()
