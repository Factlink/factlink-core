class window.TabbedMainRegionLayout extends Backbone.Marionette.Layout
  template: 'layouts/tabbed_main_region'

  regions:
    titleRegion:   'h1'
    contentRegion: '.content'
    tabsRegion:    '.tabs'