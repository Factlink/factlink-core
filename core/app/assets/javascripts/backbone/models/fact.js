window.Fact = Backbone.Model.extend({
  getOwnContainingChannels: function() {
    var containingChannels = this.get('containing_channel_ids');
    var ret = [];

    currentUser.channels.each(function(ch) {
      if ( _.indexOf(containingChannels, ch.id ) !== -1 ) {
        ret.push(ch);
      }
    });

    return ret;
  },

  dependentUrl: function(forChannel) {
    if ( forChannel ) {
      return this.collection.url() + '/' + this.get('id');
    } else {
      return '/facts/' + this.get('id');
    }
  },

  sync: function(method, model, options) {
    options = options || {};
    var forChannel = options.forChannel;

    //@TODO: Remove this strange default behaviour
    if ( forChannel === undefined ) {
      forChannel = true;
    }

    options.url = model.dependentUrl(forChannel);

    Backbone.sync(method, model, options);
  }
});