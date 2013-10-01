class window.TopicStatisticsView extends Backbone.Marionette.ItemView
  className: 'statistics'
  template: 'topics/statistics'

  initialize: ->
    @listenTo @model, 'change', @render
