var views = {};
var active_channel_id;

window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    Channels.bind('add',   this.addOneChannel, this);
    Channels.bind('reset', this.addAllChannels, this);
    Channels.bind('all',   this.render, this);
    
    // Calling toString on the channel-id because backbone stores id as string (=== comparison)
    var current_channel_id = $('#channel').data('channel-id').toString();
    
    if ( current_channel_id ) {
      this.setActiveChannel(current_channel_id);
    }
  },
  
  addOneChannel: function(channel) {
    var view = new ChannelMenuView({model: channel});
    
    views[channel.id] = view;
    
    if ( this.isActiveChannel(channel.id) ) {
      view.setActive();
    }
    
    this.$('#channel-listing').append(view.render().el);
  },
  
  addAllChannels: function() {
    var self = this;
    Channels.each(function(channel) {
      self.addOneChannel.call(self, channel);
    });
  },
  
  isActiveChannel: function(channel_id) {
    return active_channel_id === channel_id;
  },
  
  setActiveChannel: function(channel_id) {
    if ( active_channel_id ) {
      views[active_channel_id].setNotActive();
    }
        
    active_channel_id = channel_id;
    
    if ( views[active_channel_id] ) {
      views[active_channel_id].setActive();
    }
  },
  
  showFactsForChannel: function(username, channel_id) {
    var channel = Channels.get(channel_id);
    var self = this;
    
    if ( channel ) {
      $.ajax({
        url: channel.url() + '/facts',
        method: "GET",
        success: function( data ) {
          $('#main-wrapper').html(data);
          $('.fact-block').factlink();
          
          self.setActiveChannel(channel.id);
        }
      });
    }
  }
});