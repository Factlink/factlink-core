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
  }
});