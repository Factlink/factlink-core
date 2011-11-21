window.ChannelView = Backbone.View.extend({

  el: $("#main-wrapper"),
  
  initialize: function(opts) {
    this.appView = opts.appView;
  },

  setChannel: function(channel) {
    this.channel = channel;

    return this;
  },
  
  render: function() { 
    var self = this;

    if ( self.channel ) {
      self.appView.trigger('channels:loading', self.channel.id);

      $.ajax({
        url: self.channel.url() + '/facts',
        method: "GET",
        success: function( data ) {
          self.el.html(data);
          self.el.find('.fact-block').factlink();

          self.appView.trigger('channels:loaded', self.channel.id);
        }
      });
    }
  }
});

