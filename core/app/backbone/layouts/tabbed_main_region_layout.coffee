class window.TabbedMainRegionLayout extends Backbone.Marionette.Layout
  template: 'layouts/tabbed_main_region'
  showTitle: (title) ->
    @titleRegion.show(new TextView(model: new Backbone.Model(text:title)))

  setTitle: (title) ->
    @titleRegion.currentView.model.set('text',title)

  regions:
    titleRegion: 'h1'
    contentRegion: '.content'
    tabsRegion:    '.tabs'