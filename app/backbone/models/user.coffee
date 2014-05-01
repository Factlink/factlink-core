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
      @get('avatar_url').replace(/<SIZE>/g, size)

  link: -> "/user/#{@get('username')}"
  editLink: -> "#{@link()}/edit"

  feed_activities: ->
    @_feed_activities ?= new UserActivities null, user: @

  groups: ->
    unless @_groups
      @_groups = new UserGroups @get('groups'), user: @
      @on 'change:groups', => @_groups.reset @get('groups')
    @_groups

  is_following_users: ->
    !@following.isEmpty()

  follow: ->
    currentSession.user().following.create @,
      error: =>
        currentSession.user().following.remove @
        @set 'statistics_follower_count', @get('statistics_follower_count')-1

    @set 'statistics_follower_count', @get('statistics_follower_count')+1

  unfollow: ->
    self = currentSession.user().following.get(@id)
    return unless self

    self.destroy
      error: =>
        currentSession.user().following.add @
        @set 'statistics_follower_count', @get('statistics_follower_count')+1

    @set 'statistics_follower_count', @get('statistics_follower_count')-1

  followed_by_me: ->
    currentSession.user().following.some (model) =>
      model.get('username') == @get('username')

  password: -> @_password ?= new UserPassword {}, user: this

  delete: (options) ->
    # Sending data with DELETE request is not supported
    # Most browsers support it anyway, except PhantomJS
    default_options =
      type: 'POST'
      url: @url() + '/delete'
      data: {password: options.password}

    Backbone.ajax _.extend default_options, options
