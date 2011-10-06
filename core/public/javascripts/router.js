var Workspace = Backbone.Router.extend({
  initialize: function(channel_dump) {
    this.route(/([^\/]+)\/channels\/?$/, "channelOverview", this.getChannelOverview);
    this.route(/([^\/]+)\/channels\/([0-9]+|all)\/facts\/?$/, "getChannelFacts", this.getChannelFacts);
        
    // Channels.reset(channel_dump);
    
    this.view = new AppView();
  },

  getChannelOverview: function(username) {
    this.navigate(username + "/channels/all/facts", true);
  },
  
  getChannelFacts: function(username, channel_id) {
    this.view.showFactsForChannel(username, channel_id);
  }

});