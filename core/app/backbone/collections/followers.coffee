class SocialCollection extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

class window.Followers extends SocialCollection
  url: -> "/#{@user.get('username')}/followers"

  # TODO fix this mess
  addFollower: (follower) ->
    Backbone.sync 'update', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_removeFollower(follower)
    @_addFollower(follower)

  _addFollower: (follower) ->
    @add follower

  removeFollower: (follower) ->
    Backbone.sync 'delete', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_addFollower(follower)
    @_removeFollower(follower)

  _removeFollower: (follower)->
    @remove follower

  followed_by_me: ->
    !! @find (model) ->
      model.get('username') == currentUser.get('username')

class window.Following extends SocialCollection
  url: -> "/#{@user.get('username')}/following"
