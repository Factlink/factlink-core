class SocialCollection extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

class window.Followers extends SocialCollection
  url: -> "/#{@user.get('username')}/followers"

  followed_by_me: ->
    !! @find (model) ->
      model.get('username') == currentUser.get('username')

class window.Following extends SocialCollection
  url: -> "/#{@user.get('username')}/following"
