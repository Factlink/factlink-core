app = FactlinkApp

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
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    fact = new Fact(id: fact_id)
    fact.fetch
      success: (model, response) => @withFact(model, params)
      error: => FactlinkApp.NotificationCenter.error("This Factlink could not be found. <a onclick='history.go(-1);$(this).closest(\"div.alert\").remove();'>Click here to go back.</a>")

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
    app.leftBottomRegion.close()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)
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

  withFact: (fact, params={})->
    @main.contentRegion.show new DiscussionView(model: fact, tab: params.tab)

    user = new User fact.get('created_by')

    back_button = new UserBackButton [], model: user
    @main.titleRegion.show new ExtendedFactTitleView model: fact, back_button: back_button

    window.Channels.setUsernameAndRefreshIfNeeded user.get('username') # TODO: check if this can be removed
    FactlinkApp.Sidebar.showForChannelsOrTopicsAndActivateCorrectItem(window.Channels, null, user)
    user.fetch
      success: => @showSidebarProfile(user)

  showSidebarProfile: (user) ->
    sidebarProfileView = new SidebarProfileView(model: user)
    app.leftTopRegion.show(sidebarProfileView)

  makePermalinkEvent: ->
    FactlinkApp.factlinkBaseUrl = null
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', =>
      @last_profile_status =
        view: @profile_views.currentView()
        scrollTop: $('body').scrollTop()
      $('body').scrollTo(0)
