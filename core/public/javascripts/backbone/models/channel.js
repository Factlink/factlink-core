window.Channel = Backbone.Model.extend({
  initialize: function(opts) {
    var self = this;
    
    this.bind('activate', this.setActive);
    this.bind('deactivate', this.setNotActive);
    
    this.user = new User(opts.created_by);
  },
  
  setActive: function() {
    this.isActive = true;
  },
  
  setNotActive: function() {
    this.isActive = false;
  },
  
  getOwnContainingChannels: function() {
    var containingChannels = this.get('containing_channels');
    var ret = [];
    
    currentUser.channels.each(function(ch) { 
      if ( _.indexOf(containingChannels, ch.id ) !== -1 ) {
        ret.push(ch);
      }
    });
    
    return ret;
  }
});