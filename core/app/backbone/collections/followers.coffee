class window.Followers extends Backbone.Factlink.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  url: -> "/#{@user.get('username')}/followers"

class window.Following extends Backbone.Factlink.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  url: -> "/#{@user.get('username')}/following"
