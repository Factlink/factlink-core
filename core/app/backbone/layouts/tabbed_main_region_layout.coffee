class window.TabbedMainRegionLayout extends Backbone.Marionette.Layout

  template: 'layouts/tabbed_main_region'

  regions:
    titleRegion:   '.js-title-region'
    contentRegion: '.js-content-region'
    tabsRegion:    '.js-tabs-region'

  showTitle: (title) ->
    @titleRegion.show new TextView text: title, tagName: 'h1'

  setTitle: (title) ->
    @titleRegion.currentView.model.set('text',title)
