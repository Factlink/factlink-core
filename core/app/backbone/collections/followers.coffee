class SocialCollection extends Backbone.Collection
  model: User

  initialize: (models, opts) ->
    @user = opts.user

  fetch: (options={})->
    success = options.success
    new_success = (args...) =>
      @totalRecords = @length
      @followed_by_me = @followed_by_m()
      @trigger 'change'
      success(args...) if success?

    super _.extend({ success: new_success }, options)

  total_count: -> @totalRecords

  followed_by_m: ->
    @find (model) ->
      model.get('username') == currentUser.get('username')


class window.Followers extends SocialCollection
  url: -> "/#{@user.get('username')}/followers"

  initialize: (args...) ->
    super(args...)
    @followed_by_me = false

  # TODO fix this mess
  addFollower: (follower) ->
    Backbone.sync 'update', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_removeFollower()
    @_addFollower()

  _addFollower: ->
    @followed_by_me = true
    @totalRecords += 1
    @trigger 'change'

  removeFollower: (follower) ->
    Backbone.sync 'delete', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_addFollower()
    @_removeFollower()

  _removeFollower: ->
    @followed_by_me = false
    @totalRecords -= 1
    @trigger 'change'

  parse: (response) ->
    @followed_by_me = response.followed_by_me
    super(response)

class window.Following extends SocialCollection
  url: -> "/#{@user.get('username')}/following"
