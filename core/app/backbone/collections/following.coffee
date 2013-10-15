class window.Following extends Backbone.Factlink.Collection
  model: User

  initialize: (models, options) ->
    @user = options.user

  url: -> "/#{@user.get('username')}/following"
