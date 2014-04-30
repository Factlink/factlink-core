class window.UserGroups extends Backbone.Factlink.Collection
  model: Group

  initialize: (models, options) =>
    console.info options.user.get('username')
    @user = options.user

  url: ->
    username = @user.get('username')
    "/api/beta/users/#{username}/groups"