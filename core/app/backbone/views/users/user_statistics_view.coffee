class window.UserStatisticsView extends Backbone.Marionette.ItemView
  className: 'statistics'
  template: 'users/statistics'

  initialize: ->
    @listenTo @model, 'change', @render
