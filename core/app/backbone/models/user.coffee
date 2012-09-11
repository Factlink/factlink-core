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


  toJSON: () ->
    json = Backbone.Model.prototype.toJSON.apply(this);
    _.extend json,
      is_current_user: @is_current_user(),
      edit_path: '/' + @get('username') + '/edit',
      change_password_path: '/' + @get('username') + '/password/edit'
      notifications_settings_path: '/' + @get('username') + '/notification-settings'
      link: '/' + @get('username')