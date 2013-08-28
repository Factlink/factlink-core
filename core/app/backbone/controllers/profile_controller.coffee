class window.ProfileController extends Backbone.Marionette.Controller

  # ACTIONS
  showProfile: (username) ->
    @showPage username, @profile_options()
  showNotificationSettings: (username) ->
    @showPage username, @notification_options(username)

  showFact: (slug, fact_id, params={})->
    @listenTo FactlinkApp.vent, 'load_url', @close

    fact = new Fact id: fact_id
    @listenTo fact, 'destroy', @close


    fact.fetch success: =>
      @showProfile fact.user().get('username')

      @listenTo FactlinkApp.vent, 'close_discussion_modal', ->
        Backbone.history.navigate fact.user().profilePath(), true

      newClientModal = new DiscussionModalContainer
      FactlinkApp.discussionModalRegion.show newClientModal
      newClientModal.mainRegion.show new NDPDiscussionView model: fact

  onClose: ->
    FactlinkApp.discussionModalRegion.close()

  # HELPERS
  profile_options: ->
    title: 'Profile'
    active_tab: 'show'
    render: (main_region, user) =>
      main_region.show new ProfileView
        model: user
        collection: window.Channels
        created_facts_view: @getFactsView user.created_facts()

  notification_options: (username)->
    title: 'Notification Settings'
    active_tab: 'notification-settings'
    render: (main_region, user) ->
      main_region.show(new NotificationSettingsView model: user)

  showPage: (username, options) ->
    FactlinkApp.leftBottomRegion.close()
    @main = new TabbedMainRegionLayout();
    FactlinkApp.mainRegion.show(@main)
    @getUser username,
      onInit: (user) =>
        window.Channels.setUsernameAndRefreshIfNeeded user.get('username') # TODO: check if this can be removed
        FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem(window.Channels, null, user)
        @main.showTitle(options.title)
      onFetch: (user) =>
        @showSidebarProfile(user)
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

  getFactsView: (channel) ->
    new FactsView
      collection: new ChannelFacts([], channel: channel)

  showSidebarProfile: (user) ->
    sidebarProfileView = new SidebarProfileView(model: user)
    FactlinkApp.leftTopRegion.show(sidebarProfileView)
