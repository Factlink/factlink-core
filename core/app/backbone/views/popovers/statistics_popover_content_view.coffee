class window.StatisticsPopoverContentView extends Backbone.Marionette.Layout
  className: 'statistics-popover-content'

  template: 'popovers/statistics_popover_content'

  regions:
    statisticsRegion: '.js-statistics-region'
    buttonRegion: '.js-button-region'

  templateHelpers: ->
    title: @model.get('title') || @model.get('username')

  onRender: ->
    @buttonRegion.show @options.buttonView
    @statisticsRegion.show @options.statisticsView if @options.statisticsView?
