class SocialCollection extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  fetch: (options={})->
    success = options.success
    new_success = (args...) =>
      @totalRecords = @length
      @trigger 'change'
      success(args...) if success?

    super _.extend({ success: new_success }, options)

  total_count: -> @totalRecords

class window.Followers extends SocialCollection
  url: -> "/#{@user.get('username')}/followers"

  initialize: (args...) ->
    super(args...)

  # TODO fix this mess
  addFollower: (follower) ->
    Backbone.sync 'update', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_removeFollower(follower)
    @_addFollower(follower)

  _addFollower: (follower) ->
    @add follower
    @totalRecords += 1
    @trigger 'change'

  removeFollower: (follower) ->
    Backbone.sync 'delete', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_addFollower(follower)
    @_removeFollower(follower)

  _removeFollower: (follower)->
    @remove follower
    @totalRecords -= 1
    @trigger 'change'

  followed_by_me: ->
    !! @find (model) ->
      model.get('username') == currentUser.get('username')

class window.Following extends SocialCollection
  url: -> "/#{@user.get('username')}/following"
