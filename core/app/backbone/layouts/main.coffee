class crossFadeRegion extends Backbone.Marionette.Region
  el: '#left-column .left-top-x-fade'

  theTimeout: 560

  crossFade: (newView) ->
    currentView = @currentView

    if currentView
      @.$el.fadeOut(@theTimeout, () =>
        @show(newView)
      )
    else
      @show(newView)

  open: (view) ->
    @.$el.hide();
    @.$el.html(view.el);
    @.$el.fadeIn(@theTimeout);


FactlinkApp.addRegions
  mainRegion:          '#main-wrapper'
  notificationsRegion: '#notifications'

  leftTopXFadeRegion:  crossFadeRegion
  leftTopRegion:       '#left-column .user-block-container'
  leftBottomRegion:    '#left-column .related-channels'
  leftMiddleRegion:    '#left-column .channel-listing-container'