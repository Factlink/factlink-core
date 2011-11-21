window.RelatedUsersView = Backbone.View.extend({

  el: $("#right-column .related-users"),
  
  initialize: function() { 
  },

  setChannel: function(channel) {
    this.channel = channel;

    return this;
  },
  
  render: function() { 
    var self = this;

    if ( this.channel ) {
      $.ajax({
        url: this.channel.url() + '/related_users',
        method: "GET",
        success: function( data ) {
          self.el.html(data);
        }
      });
    }
  }
});
