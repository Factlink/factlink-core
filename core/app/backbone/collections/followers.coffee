class window.Followers extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  url: -> "/#{@user.get('username')}/followers"

class window.Following extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  url: -> "/#{@user.get('username')}/following"
