count_object_or_null = (count) ->
  if count? then {count: count} else null

class window.UserStatisticsView extends Backbone.Marionette.ItemView
  className: 'statistics'
  template: 'users/statistics'

  templateHelpers: =>
    following: count_object_or_null @model.following.length
    followers: count_object_or_null @model.followers.length

  initialize: ->
    @listenTo @model.followers, 'all', @render
    @listenTo @model.following, 'all', @render
    @model.followers.fetch()
    @model.following.fetch()
