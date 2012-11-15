FactlinkApp.addInitializer (options)->
  new ProfileRouter controller: new ProfileController # first, as then it doesn't match index pages such as "/m" using "/:username"
  new ChannelsRouter controller: new ChannelsController
  new ConversationsRouter controller: new ConversationsController
  new TourRouter controller: new TourController
