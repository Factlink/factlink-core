window.ChannelActivities = Backbone.Collection.extend({
  model: Activity,

  initialize: function(models, opts) {
    this.channel = opts.channel;
  },

  url: function() {
    return '/' + this.channel.get('created_by').username + '/channels/' + this.channel.get('id') + '/activities.json';
  }
});

_.extend(ChannelActivities.prototype, AutoloadCollectionOnTimestamp);