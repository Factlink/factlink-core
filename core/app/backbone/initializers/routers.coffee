FactlinkApp.addInitializer (options)->
  new ChannelsRouter controller: new ChannelsController
  new ProfileRouter controller: new ProfileController
  new TourRouter controller: new TourController
  new MessagesRouter controller: new MessagesController
