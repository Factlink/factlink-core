class window.Followers extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  url: -> "/#{@user.get('username')}/followers"

  followed_by_me: ->
    @some (model) ->
      model.get('username') == currentUser.get('username')

class window.Following extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  url: -> "/#{@user.get('username')}/following"
