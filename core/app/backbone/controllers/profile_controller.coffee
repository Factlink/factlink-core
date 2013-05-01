class window.ProfileController extends Backbone.Factlink.BaseController

  routes: ['showProfile', 'showNotificationSettings', 'showFact']

  onShow:   -> @profile_views = new Backbone.Factlink.DetachedViewCache
  onClose:  -> @profile_views.cleanup()
  onAction: -> @unbindFrom @permalink_event if @permalink_event?

  # CACHE HELPERS
  restoreProfileView: (username, new_callback) ->
    if @last_profile_status?
      view = @profile_views.switchCacheView( username )
      $('body').scrollTo(@last_profile_status.scrollTop) if view == @last_profile_status?.view
      delete @last_profile_status
    @profile_views.clearUnshowedViews()

    @profile_views.renderCacheView( username, new_callback() ) unless view?

  # ACTIONS
  showProfile: (username) ->
    @showPage username, @profile_options(username)
  showNotificationSettings: (username) ->
    @showPage username, @notification_options(username)

  showFact: (slug, fact_id, params={})->
    fact = new Fact(id: fact_id)
    user = new User fact.get('created_by')
    back_button = new UserBackButton [], model: user

    fact.on 'change', (fact)=>
      user.set fact.get('created_by')
      FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem(window.Channels, null, user)
      @showSidebarProfile(user)

    FactlinkApp.mainRegion.show new DiscussionPageView
      model: fact
      back_button: back_button
      tab: params.tab

  # HELPERS
  profile_options: (username) ->
    title: 'Profile'
    active_tab: 'show'
    render: (main_region, user) =>
      @makePermalinkEvent()

      main_region.show @profile_views

      @restoreProfileView username, =>
        new ProfileView
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
    usertabs.on 'showProfile',       => @switchToPage(username, user, userjson.link , @profile_options(username))
    usertabs.on 'showNotifications', => @switchToPage(username, user,userjson.notifications_settings_path, @notification_options(username))

  getUser: (username, options) ->
    user = new User(username: username)
    options.onInit(user)
    user.fetch
      success: -> options.onFetch(user)
      forProfile: true

  getFactsView: (channel) ->
    collection = new ChannelFacts [], channel: channel
    facts_view = new FactsView collection: collection

  showSidebarProfile: (user) ->
    sidebarProfileView = new SidebarProfileView(model: user)
    FactlinkApp.leftTopRegion.show(sidebarProfileView)

  makePermalinkEvent: ->
    FactlinkApp.factlinkBaseUrl = null
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', =>
      @last_profile_status =
        view: @profile_views.currentView()
        scrollTop: $('body').scrollTop()
      $('body').scrollTo(0)
