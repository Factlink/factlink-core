class window.crossFadeRegion extends Backbone.Marionette.Region
  el: '#left-column .left-top-x-fade'

  theTimeout: 560,

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