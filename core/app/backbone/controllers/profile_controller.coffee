app = FactlinkApp

class window.ProfileController extends Backbone.Factlink.BaseController

  routes: ['showProfile', 'showNotificationSettings']

  profile_options: (username) ->
    title: 'About ' + username
    active_tab: 'show'
    mainRegion: (user) ->
      new ProfileView
        model: user
        collection: window.Channels.orderedByAuthority()

  notification_options: (username)->
    title: 'Notification Settings'
    active_tab: 'notification-settings'
    mainRegion: (user) ->
      new NotificationSettingsView model: user

  # ACTIONS
  showProfile: (username) -> @showPage username, @profile_options(username)
  showNotificationSettings: (username) -> @showPage username, @notification_options(username)

  # HELPERS
  showPage: (username, options) ->
    app.leftBottomRegion.close()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)
    @getUser username,
      onInit: (user) =>
        @setChannelListing(username)
        @main.showTitle(options.title)
      onFetch: (user) =>
        @showUserLarge(user)
        @main.tabsRegion.show(@getUserTabs(user, options.active_tab))
        @main.contentRegion.show(options.mainRegion(user))

  switchToPage: (username, user, path, options)->
    @main.setTitle options.title
    @main.tabsRegion.currentView.activate(options.active_tab)
    @main.contentRegion.show(options.mainRegion(user))
    Backbone.history.navigate path, false

  getUserTabs: (user, active_tab) ->
    usertabs = new UserTabsView(model: user, active_tab: active_tab)
    username = user.get('username')
    userjson = user.toJSON()
    usertabs.on 'showProfile',       => @switchToPage(username, user, userjson.link , @profile_options(username))
    usertabs.on 'showNotifications', => @switchToPage(username, user,userjson.notifications_settings_path, @notification_options(username))

  getUser: (username, options) ->
    user = new User(username: username)
    options.onInit(user)
    user.fetch
      success: -> options.onFetch(user)
      forProfile: true

  showUserLarge: (user) ->
    userLargeView = new UserLargeView(model: user);
    app.leftTopRegion.show(userLargeView);

  setChannelListing: (username) ->
    changed = window.Channels.setUsernameAndRefresh(username)
    channelCollectionView = new ChannelsView(collection: window.Channels)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActive('profile')
