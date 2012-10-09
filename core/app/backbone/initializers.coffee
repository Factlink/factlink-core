FactlinkApp.addInitializer (options)->
  if ( $('#notifications').length == 1 )
    #The notifications-icon is present in the topbar, create the appropriate Backbone View
    notificationsView = new NotificationsView(
      el : $('#notifications')
      collection: new Notifications()
    )

    FactlinkApp.notificationsRegion.attachView(notificationsView)

FactlinkApp.addInitializer (options)->
  window.Channels = new ChannelList()
  window.TitleManager = new WindowTitle()

  window.Global = {}

  window.Global.TitleView = new TitleView(model: window.TitleManager, collection: window.Channels, el: 'title')
  window.Global.TitleView.render()

FactlinkApp.addInitializer (options)->
  new ChannelsRouter controller: new ChannelsController
  new ProfileRouter controller: new ProfileController
  new TourRouter controller: new TourController
  new MessagesRouter controller: new MessagesController

FactlinkApp.addInitializer (options)->
  FactlinkApp.vent.on 'require_login', ()->
    $('body').html ''
    $('body').css(
      'background-color': '#313131'
      width:'100%'
      height:'100%'
    )

    alert "You have been signed out, please sign in."
    window.location = Factlink.Global.path.sign_in