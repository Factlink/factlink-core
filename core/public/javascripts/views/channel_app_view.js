var views = {};
var active_channel_id;

window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    Channels.bind('add',   this.addOneChannel, this);
    Channels.bind('reset', this.resetChannels, this);
    Channels.bind('all',   this.render, this);
    
    var current_channel_id = $('#channel').data('channel-id');
    
    if ( current_channel_id ) {
      // Calling toString on the channel-id because backbone 
      // stores id as string (=== comparison)
      this.setActiveChannel(current_channel_id.toString());
    }
    
    // this.setupChannelReloading();
  },

  setupChannelReloading: function(){
    var args = arguments;
    setTimeout(function(){
      Channels.fetch({
        success: args.callee
      });
    }, 7000);
  },
  
  addOneChannel: function(channel) {
    var view = new ChannelMenuView({model: channel});
    
    views[channel.id] = view;
    
    if ( this.isActiveChannel(channel.id) ) {
      view.setActive();
    }
    
    this.$('#channel-listing').append(view.render().el);
  },
  
  resetChannels: function() {
    var self = this;
    _.each(views,function(view) {
      view.remove();
    });
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
  
  openChannel: function(username, channel_id) {
    var channel = Channels.get(channel_id);
    var self = this;
    
    views[channel_id].setLoading();
    
    if ( channel ) {
      // Might seem a bit ugly but this method makes sure that after the two ajax
      // calls are done, the loader is set to loaded as well.
      var ready = (function() {
        var count = 0;
        
        return function() {
          if (++count === 2) {
            self.setActiveChannel(channel.id);

            views[channel_id].stopLoading();
          }
        };
      })();
      
      $.ajax({
        url: channel.url() + '/facts',
        method: "GET",
        success: function( data ) {
          $('#main-wrapper').html(data);
          $('.fact-block').factlink();
          
          ready();
        }
      });
      
      $.ajax({
        url: channel.url() + '/related_users',
        method: "GET",
        success: function( data ) {
          $('#right-column').html(data);
          
          ready();
        }
      });
    }
  }
});
