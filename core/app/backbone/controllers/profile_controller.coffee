app = FactlinkApp

class window.ProfileController extends Backbone.Factlink.BaseController

  routes: ['showProfile', 'showNotificationSettings', 'showFact']

  onShow:   -> @profile_views = new Backbone.Factlink.DetachedViewCache
  onClose:  -> @profile_views.cleanup()
  onAction: -> @unbindFrom @permalink_event if @permalink_event?

  # CACHE HELPERS
  restoreProfileView: (username, new_callback) ->
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

  showFact: (slug, fact_id)->
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    fact = new Fact(id: fact_id)
    fact.fetch
      success: (model, response) => @withFact(model)

  # HELPERS
  profile_options: (username) ->
    title: 'About ' + username
    active_tab: 'show'
    render: (main_region, user) =>
      @makePermalinkEvent()

      main_region.show @profile_views

      @restoreProfileView username, =>
        new ProfileView
          model: user
          collection: window.Channels.orderedByAuthority()
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
        @setChannelListing(username)
        @main.showTitle(options.title)
      onFetch: (user) =>
        @showUserLarge(user)
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
    facts_view = new FactsView
        collection: collection,
        model: channel

  withFact: (fact)->
    window.efv = new DiscussionView(model: fact)
    @main.contentRegion.show(efv)

    username = fact.get('created_by').username
    return_to_text = "#{ username.capitalize() }'s profile"

    title_view = new ExtendedFactTitleView(
                        model: fact,
                        return_to_url: username,
                        return_to_text: return_to_text )

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

  makePermalinkEvent: ->
    @permalink_event = @bindTo FactlinkApp.vent, 'factlink_permalink_clicked', (e, fact) =>
      @last_profile_status =
        view: @profile_views.currentView()
        scrollTop: $('body').scrollTop()

      navigate_to = fact.get('url')
      Backbone.history.navigate navigate_to, true
      $('body').scrollTo(0)

      e.preventDefault()
      e.stopPropagation()
