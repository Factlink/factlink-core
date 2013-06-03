class SocialCollection extends Backbone.Paginator.requestPager
  model: User,
  server_api:
      take: -> @perPage
      skip: -> (@currentPage-1) * @perPage

  paginator_core:
    dataType: "json",
    url: -> @url()

  paginator_ui:
    perPage: 3
    firstPage: 1
    currentPage: 1

  initialize: (models, opts) ->
    @user = opts.user
    @_followed_by_me = false
    @totalRecords = null

  parse: (response) ->
    @totalRecords = response.total
    @totalPages = Math.floor(response.total / @perPage)
    response

  fetch: ->
    super success: =>
      @trigger 'change'

  total_count: ->
    @totalRecords


class window.Followers extends SocialCollection
  url: -> "/#{@user.get('username')}/followers"


  # TODO fix this mess
  addFollower: (follower) ->
    Backbone.sync 'update', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_removeFollower()
    @_addFollower()

  _addFollower: ->
    @_followed_by_me = true
    @totalRecords += 1
    @trigger 'change'

  removeFollower: (follower) ->
    Backbone.sync 'delete', follower,
      url: "#{@url()}/#{follower.get('username')}"
      error: => @_addFollower()
    @_removeFollower()

  _removeFollower: ->
    @_followed_by_me = false
    @totalRecords -= 1
    @trigger 'change'

  parse: (response) ->
    @_followed_by_me = response.followed_by_me
    super(response)

  followed_by_me: ->
    @_followed_by_me

class window.Following extends SocialCollection
  url: -> "/#{@user.get('username')}/following"
