class window.ChannelActivities extends Backbone.Collection
  model: Activity

  initialize: (models, opts) ->
    @channel = opts.channel;

  url:  ()-> '/' + this.channel.get('created_by').username + '/channels/' + this.channel.get('id') + '/activities';
  link: ()-> '/' + this.channel.get('created_by').username + '/channels/' + this.channel.get('id') + '/activities';

_.extend(ChannelActivities.prototype, AutoloadCollectionOnTimestamp);
