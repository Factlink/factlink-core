var Workspace = Backbone.Router.extend({
  initialize: function(data) {
    this.route(/([^\/]+)\/channels\/?/, "channelOverview", this.getChannelOverview);
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/facts\/?/, "getChannelFacts", this.getChannelFacts);
    
    this.view = new AppView();
    
    Channels.reset(channel_dump);
  },
  
  // routes: {
  //     ":username/channels": "getChannelOverview",
  //     ":username/channels/:channel_id/facts": "getChannelFacts"
  //   },

  getChannelOverview: function(username) {
    console.info( "getChannelOverview" );
    this.navigate(username + "/channels/all/facts", true);
  },
  
  getChannelFacts: function(username, channel_id) {
    console.info( "getChannelFacts" );
    this.view.showFactsForChannel(username, channel_id);
  }

});

var Router = new Workspace();

Backbone.history.start({pushState:true});