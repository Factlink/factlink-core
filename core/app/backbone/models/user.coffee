class window.User extends Backbone.Model
  initialize: () -> @channels = []

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
    json = Backbone.Model.prototype.toJSON.apply(this);
    username = @get('username')
    _.extend json,
      is_current_user: @is_current_user(),
      edit_path: "/#username/edit",
      change_password_path: "/#{username}/password/edit"
      notifications_settings_path: "/#{username}/notification-settings"
      link: "/#{username}"
      avatar_url_40: @avatar_url(40)
      avatar_url_48: @avatar_url(48)
      avatar_url_200: @avatar_url(200)
      stream_path: "/#{username}/channels/#{@get('all_channel_id')}/activities"
      profile_path: "/#{username}"
