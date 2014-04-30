class window.UserActivities extends Backbone.Factlink.Collection
  _.extend @prototype, AutoloadCollectionOnTimestamp
  model: Activity

  initialize: (models, options) ->
    @user = options.user

  url: -> "/api/beta/users/#{@user.get('username')}/feed"
