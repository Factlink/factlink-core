window.Fact = Backbone.Model.extend({
  getOwnContainingChannels: function() {
    var containingChannels = this.get('containing_channels');
    var ret = [];
    
    currentUser.channels.each(function(ch) { 
      if ( _.indexOf(containingChannels, ch.id ) !== -1 ) {
        ret.push(ch);
      }
    });
    
    return ret;
  },
  
  specialUrl: function(forChannel) {
    if ( forChannel ) {
      return this.collection.url() + '/' + this.get('id');
    } else {
      return '/facts/' + this.get('id');
    }
  },
  
  sync: function(method, model, options) {
    options = options || {};
    var forChannel = options.forChannel;
    
    if ( forChannel === undefined ) {
      forChannel = true;
    }
    
    options.url = model.specialUrl(forChannel);

    Backbone.sync(method, model, options);
  }
});