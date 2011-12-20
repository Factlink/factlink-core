window.ActivitiesView = Backbone.View.extend({

  el: $("#right-column #activity-listing"),
  
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
        url: this.channel.url() + '/activities',
        method: "GET",
        success: function( data ) {
          self.el.html(data);
        }
      });
    }
  }
});
