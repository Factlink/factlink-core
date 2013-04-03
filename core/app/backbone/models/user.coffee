class window.User extends Backbone.Model
  initialize: -> @channels = []

  setChannels: (channels) -> @channels = channels

  url: (forProfile) ->
    if (forProfile)
      '/' + this.get('username') + ".json"
    else
      '/' + this.get('username')

  sync: (method, model, options)->
    options = options || {};
    forProfile = options.forProfile;

    options.url = model.url(forProfile);

    Backbone.sync(method, model, options);

  is_current_user: ->
    window.currentUser != undefined && currentUser.get('id') == this.get('id')

  avatar_url: (size)->
    md5d_email = @get('gravatar_hash')
    "https://secure.gravatar.com/avatar/#{md5d_email}?size=#{size}&rating=PG&default=retro"

  stream:        -> @channel_with_id 'all_channel_id'
  created_facts: -> @channel_with_id 'created_facts_channel_id'

  channel_with_id: (id) ->
    new Channel
      id: @get(id)
      created_by:
        username: @get('username')

  toJSON: ->
    username = @get('username')
    _.extend super(),
      is_current_user: @is_current_user(),
      edit_path: "/#{username}/edit",
      change_password_path: "/#{username}/password/edit"
      notifications_settings_path: "/#{username}/notification-settings"
      link: "/#{username}"
      avatar_url_20: @avatar_url(20)
      avatar_url_24: @avatar_url(24)
      avatar_url_32: @avatar_url(32)
      avatar_url_42: @avatar_url(42)
      avatar_url_48: @avatar_url(48)
      avatar_url_80: @avatar_url(80)
      avatar_url_160: @avatar_url(160)
      stream_path: "/#{username}/channels/#{@get('all_channel_id')}/activities"
      profile_path: "/#{username}"

  follow: (user) ->
    username        = window.currentUser.get('username')
    follow_username = user.get('username')
    follow_url       = "#{username}/follow/#{follow_username}"

    @set('followed?', true)
    $.ajax
      url: follow_url
      type: 'post'
      error: => @set('followed?', false)

  unfollow: (user) ->
    username        = window.currentUser.get('username')
    follow_username = user.get('username')
    unfollow_url    = "#{username}/unfollow/#{follow_username}"

    @set('followed?', false)
    $.ajax
      url: unfollow_url
      type: 'delete'
      error: => @set('followed?', true)
