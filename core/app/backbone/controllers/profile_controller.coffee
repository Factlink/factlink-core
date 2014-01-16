class window.ProfileController extends Backbone.Marionette.Controller

  # ACTIONS
  showProfile: (username) ->
    @showPage username, @profile_options()

  showNotificationSettings: (username) ->
    @showPage username, @notification_options(username)

  # HELPERS
  profile_options: ->
    title: 'Profile'
    active_tab: 'show'
    render: (main_region, user) =>
      if user.get('deleted')
        main_region.show new TextView text: 'This profile has been deleted.'
      else
        channels = new ChannelList([], username: user.get('username'))
        channels.fetch()
        main_region.show new ProfileView
          model: user
          collection: channels
          created_facts_view: @getFactsView user

  notification_options: (username)->
    title: 'Notification Settings'
    active_tab: 'notification-settings'
    render: (main_region, user) ->
      main_region.show(new NotificationSettingsView model: user)

  showPage: (username, options) ->
    $(window).scrollTop(0)

    @main = new TabbedMainRegionLayout();
    FactlinkApp.mainRegion.show(@main)
    @getUser username,
      onInit: (user) =>
        @main.showTitle(options.title)
      onFetch: (user) =>
        @main.tabsRegion.show(@getUserTabs(user, options.active_tab))
        options.render(@main.contentRegion, user)

  switchToPage: (username, user, path, options)->
    @main.setTitle options.title
    @main.tabsRegion.currentView.activate(options.active_tab)
    options.render(@main.contentRegion, user)
    Backbone.history.navigate path, false

  getUserTabs: (user, active_tab) ->
    usertabs = new UserTabsView(model: user, active_tab: active_tab)
    username = user.get('username')
    userjson = user.toJSON()
    usertabs.on 'showProfile',       => @switchToPage(username, user, userjson.link , @profile_options())
    usertabs.on 'showNotifications', => @switchToPage(username, user,userjson.notifications_settings_path, @notification_options(username))

  getUser: (username, options) ->
    user = new User(username: username)
    options.onInit(user)
    user.fetch
      success: -> options.onFetch(user)

  getFactsView: (user) ->
    new FactsView
      collection: new CreatedFacts([], user: user)
      empty_view: new EmptyProfileFactsView
