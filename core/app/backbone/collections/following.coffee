class window.Following extends Backbone.Factlink.Collection
  model: User

  initialize: (models, options) ->
    @user = options.user

  url: -> "/user/#{@user.get('username')}/following"
