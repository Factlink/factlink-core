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

  is_current_user: ()->
    window.currentUser != undefined && currentUser.get('id') == this.get('id')

  avatar_url: (size)->
    md5d_email = @get('gravatar_hash')
    "https://secure.gravatar.com/avatar/#{md5d_email}?size=#{size}&rating=PG&default=retro"


  toJSON: () ->
    json = Backbone.Model.prototype.toJSON.apply(this);
    _.extend json,
      is_current_user: @is_current_user(),
      edit_path: '/' + @get('username') + '/edit',
      change_password_path: '/' + @get('username') + '/password/edit'
      notifications_settings_path: '/' + @get('username') + '/notification-settings'
      link: '/' + @get('username')
      avatar_url_48: @avatar_url(48)