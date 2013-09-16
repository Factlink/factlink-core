class window.UserStatisticsView extends Backbone.Marionette.ItemView
  className: 'statistics'
  template: 'users/statistics'

  templateHelpers: =>
    following: @model.following.length
    followers: @model.followers.length
    followingLoading: @model.following.loading()
    followersLoading: @model.followers.loading()

  initialize: ->
    @listenTo @model.followers, 'all', @render
    @listenTo @model.following, 'all', @render
    @model.followers.fetch()
    @model.following.fetch()
