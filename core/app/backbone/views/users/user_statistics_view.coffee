class window.UserStatisticsView extends Backbone.Marionette.ItemView
  className: 'statistics'
  template: 'users/statistics'

  templateHelpers: =>
    topic: @model.user_topics().first()?.toJSON()

  initialize: ->
    @listenTo @model, 'change', @render
