app = FactlinkApp

class window.ProfileController extends Backbone.Factlink.BaseController

  routes: ['showProfile', 'showNotificationSettings', 'showFact']

  # ACTIONS
  showProfile: (username) -> @showPage username, @profile_options(username)
  showNotificationSettings: (username) -> @showPage username, @notification_options(username)

  showFact: (slug, fact_id)->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    fact = new Fact(id: fact_id)
    fact.fetch
      success: (model, response) => @withFact(model)

  # HELPERS
  profile_options: (username) ->
    title: 'About ' + username
    active_tab: 'show'
    mainRegion: (user) =>
      @makePermalinkEvent( user.get('username') )

      new ProfileView
        model: user
        collection: window.Channels.orderedByAuthority()
        created_facts_view: @getFactsView user.created_facts()

  notification_options: (username)->
    title: 'Notification Settings'
    active_tab: 'notification-settings'
    mainRegion: (user) ->
      new NotificationSettingsView model: user

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

  getFactsView: (channel) ->
    collection = new ChannelFacts [], channel: channel
    facts_view = new FactsView
        collection: collection,
        model: channel

  withFact: (fact)->
    window.efv = new ExtendedFactView(model: fact)
    @main.contentRegion.show(efv)

    username = fact.get('created_by').username

    title_view = new ExtendedFactTitleView(
                        model: fact,
                        return_to_url: username,
                        return_to_text: username.capitalize() )

    @main.titleRegion.show( title_view )

    @showChannelListing(fact.get('created_by').username)

  showChannelListing: (username)->
    changed = window.Channels.setUsernameAndRefresh(username)
    channelCollectionView = new ChannelsView(collection: window.Channels)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActive('profile')


  showUserLarge: (user) ->
    userLargeView = new UserLargeView(model: user);
    app.leftTopRegion.show(userLargeView);

  setChannelListing: (username) ->
    changed = window.Channels.setUsernameAndRefresh(username)
    channelCollectionView = new ChannelsView(collection: window.Channels)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActive('profile')

  makePermalinkEvent: (baseUrl) ->
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', (e, fact) =>
      navigate_to = fact.get('url')
      Backbone.history.navigate navigate_to, true

      e.preventDefault()
      e.stopPropagation()
