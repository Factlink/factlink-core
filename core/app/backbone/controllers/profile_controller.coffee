class window.ProfileRouter extends Backbone.Router
  routes:
    ':username': 'showProfile'
    ':username/notification-settings': 'showNotificationSettings'

  showProfile: (username) ->
    user = new User(username: username)
    user.fetch()

    FactlinkApp.mainRegion.show new ReactView component:
      ReactProfile model: user

  showNotificationSettings: (username) ->
    user = new User(username: username)
    user.fetch()

    FactlinkApp.mainRegion.show new ReactView
      component: ReactNotificationSettings
        model: user
