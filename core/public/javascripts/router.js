var Workspace = Backbone.Router.extend({
  
  initialize: function(data) {
    this.view = new AppView();
    
    Channels.reset(channel_dump);
  },
  
  routes: {
    ":username/channels":                     "getChannelOverview",
    ":username/channels/:channel_id/facts":   "getChannelFacts"
  },

  getChannelOverview: function(username) {
    console.info( "Don't know just yet how to handle this one" );
  },

  getChannelFacts: function(username, channel_id) {
    this.view.showFactsForChannel(username, channel_id);
  }

});

var Router = new Workspace();

Backbone.history.start();