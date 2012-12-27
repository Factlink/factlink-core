class Factlink.DetachableViewsRegion extends Backbone.Marionette.Region
  initialize: ->
    @cache_views = {}
    @cache_view_rendered = {}
    @view_constructors = {}
    @on 'close', @_onClose, @

  defineViews: (constructors) -> @view_constructors = constructors
  getView: (name) -> @cache_views[name] ?= @_createView(name)
  isRendered: (name) -> @cache_view_rendered[name]?

  attach: (view) ->
    @currentView = view
    @$el.html(@currentView.$el)

  detach: ->
    @currentView?.$el.detach()
    delete @currentView

  switchTo: (name) ->
    @detach()

    view = @getView(name)
    if @isRendered(name)
      @attach view
    else
      @show view

  _onClose: ->
    for name, view of @cache_views
      view.close()
    delete @cache_views
    delete @view_constructors

  _createView: (name) -> 
    view = @view_constructors[name]()
    @bindTo view, 'render', => @cache_view_rendered[name] = true
    view
