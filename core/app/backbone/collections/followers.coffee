class window.Followers extends Backbone.Paginator.requestPager
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
    @totalRecords = 0

  url: -> "/#{@user.get('username')}/followers"

  addFollower: (follower) ->
    Backbone.sync('update', follower, url: "#{@url()}/#{follower.get('username')}" )
    @_followed_by_me = true
    @trigger 'change'

  removeFollower: (follower) ->
    Backbone.sync('delete', follower, url: "#{@url()}/#{follower.get('username')}" )
    @_followed_by_me = false
    @trigger 'change'

  parse: (response) ->
    @totalRecords = response.total
    @totalPages = Math.floor(response.total / @perPage)
    @_followed_by_me = response.followed_by_me
    response

  fetch: ->
    super success: =>
      @trigger 'change'

  followed_by_me: ->
    @_followed_by_me

  followers_count: ->
    @totalRecords
