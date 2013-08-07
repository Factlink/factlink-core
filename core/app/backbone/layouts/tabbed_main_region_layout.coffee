class window.TabbedMainRegionLayout extends Backbone.Marionette.Layout
  template: 'layouts/tabbed_main_region'
  showTitle: (title) ->
    @titleRegion.show(new TextView(model: new Backbone.Model(text:title), tagName: 'h1'))

  setTitle: (title) ->
    @titleRegion.currentView.model.set('text',title)

  regions:
    titleRegion:   '.js-title-region'
    contentRegion: '.content'
    tabsRegion:    '.tabs'
