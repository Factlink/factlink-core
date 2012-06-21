window.ChannelActivities = Backbone.Collection.extend({
  model: Activity,

  initialize: function(models, opts) {
    this.channel = opts.channel;
  },

  url: function() {
    return this.channel.url() + '/activities.json';
  }
});
