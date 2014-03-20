class window.User extends Backbone.Model
  _.extend @prototype, Backbone.Factlink.ModelJustCreatedMixin

  initialize: ->
    @following = new Following([], user: @)

  url: ->
    # We do this because we cannot (yet) set the idAttribute to "username"
    if @collection?
      @collection.url() + '/' + @get('username')
    else
      '/api/beta/users/' + @get('username')

  avatar_url: (size) ->
    if(window.test_counter)
      'about:blank'
    else
      md5d_email = @get('gravatar_hash')
      "https://secure.gravatar.com/avatar/#{md5d_email}?size=#{size}&rating=PG&default=retro"

  link: -> "/#{@get('username')}"

  feed_activities: ->
    @_feed_activities ?= new UserActivities null, user: @

  is_following_users: ->
    !@following.isEmpty()

  follow: ->
    currentUser.following.create @,
      error: =>
        currentUser.following.remove @
        @set 'statistics_follower_count', @get('statistics_follower_count')-1

    @set 'statistics_follower_count', @get('statistics_follower_count')+1
    mp_track 'User: Followed'

  unfollow: ->
    self = currentUser.following.get(@id)
    return unless self

    self.destroy
      error: =>
        currentUser.following.add @
        @set 'statistics_follower_count', @get('statistics_follower_count')+1

    @set 'statistics_follower_count', @get('statistics_follower_count')-1
    mp_track 'User: Unfollowed'

  followed_by_me: ->
    currentUser.following.some (model) =>
      model.get('username') == @get('username')
