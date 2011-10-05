views = [];

window.AppView = Backbone.View.extend({
  el: $('#container'),
  
  initialize: function() {
    Channels.bind('add',   this.addOneChannel, this);
    Channels.bind('reset', this.addAllChannels, this);
    Channels.bind('all',   this.render, this);
  },
  
  addOneChannel: function(channel) {
    var view = new ChannelMenuView({model: channel});
    
    views.push( view );
    
    this.$('#channel-listing').append(view.render().el);
  },
  
  addAllChannels: function() {
    Channels.each(this.addOneChannel);
  },
  
  showFactsForChannel: function(username, channel_id) {
    var channel = Channels.get(channel_id);
    
    if ( channel ) {
      $.ajax({
        url: channel.url() + '/facts',
        method: "GET",
        success: function( data ) {
          $('#main-wrapper').html(data);
          $('.fact-block').factlink();

          // TODO: This must be easier. Can't we access the view from the model?
          $('#channel-listing li').removeClass('active');
          for (var i=0; i<views.length; i++) {
            if (views[i].model === channel) {
              views[i].setActive();
            }
          }
        }
      });
    }
  }
});