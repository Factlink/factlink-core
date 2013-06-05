class Backbone.Factlink.CachingController extends Backbone.Factlink.BaseController
  openController: ->
    super
    @cached_views = new Backbone.Factlink.DetachedViewCache

  closeController: ->
    super
    @cached_views.cleanup()

  onAction: -> @unbindFrom @permalink_event if @permalink_event?

  makePermalinkEvent: (baseUrl=null)->
    FactlinkApp.factlinkBaseUrl = baseUrl
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', =>
      @lastStatus =
        view: @cached_views.currentView()
        scrollTop: $('body').scrollTop()
      $('body').scrollTo(0)

  restoreCachedView: (identifier, new_callback) ->
    if @lastStatus?
      view = @cached_views.switchCacheView(identifier)
      $('body').scrollTo(@lastStatus.scrollTop) if view == @lastStatus?.view
      delete @lastStatus

    @cached_views.clearUnshowedViews()

    @cached_views.renderCacheView(identifier, new_callback()) if not view?
