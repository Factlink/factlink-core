class SocialCollection extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  fetch: (options={})->
    success = options.success
    new_success = (args...) =>
      @trigger 'change'
      success(args...) if success?

    super _.extend({ success: new_success }, options)

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
    @trigger 'change'

  removeFollower: (follower) ->
    Backbone.sync 'delete', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_addFollower(follower)
    @_removeFollower(follower)

  _removeFollower: (follower)->
    @remove follower
    @trigger 'change'

  followed_by_me: ->
    !! @find (model) ->
      model.get('username') == currentUser.get('username')

class window.Following extends SocialCollection
  url: -> "/#{@user.get('username')}/following"
