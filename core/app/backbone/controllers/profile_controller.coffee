class window.ProfileRouter extends Backbone.Router
  routes:
    ':username': 'showProfile'
    ':username/edit': 'showProfileEdit'
    ':username/notification-settings': 'showNotificationSettings'
    ':username/change-password': 'showChangePassword'

  showProfile: (username) ->
    user = new User(username: username)
    user.fetch()

    FactlinkApp.mainRegion.show new ReactView
      component: ReactProfile model: user

  showProfileEdit: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactProfileEdit model: currentSession.user()

  showNotificationSettings: (username) ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactNotificationSettings model: currentSession.user()

  showChangePassword: ->
    FactlinkApp.mainRegion.show new ReactView
      component: ReactChangePassword model: currentSession.user().password()
