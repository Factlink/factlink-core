window.ChannelView = Backbone.View.extend({

  el: $("#main-wrapper"),
  tmpl: $('#channel_overview').html(),
  
  initialize: function(opts) {
  },

  setChannel: function(channel) {
    this.channel = channel;

    return this;
  },
  
  render: function() { 
    var self = this;

    if ( self.channel ) {
      self.channel.trigger('loading');
      
      this.$( this.el )
        .html( $.mustache(this.tmpl, this.channel.toJSON() ));
    
      $.ajax({
        url: self.channel.url() + '/facts',
        method: "GET",
        success: function( data ) {
          self.el.html(data);
          self.el.find('.fact-block').factlink();
          
          self.channel.trigger('loaded')
                      .trigger('activate', self.channel);
        }
      });
    }
  }
});

