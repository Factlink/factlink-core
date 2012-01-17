window.RelatedUsersView = Backbone.View.extend({

  el: $("#left-column .related-users"),
  
  initialize: function() { 
  },

  setChannel: function(channel) {
    this.model = channel;

    return this;
  },
  
  render: function() { 
    var self = this;

    if ( this.model ) {
      $.ajax({
        url: this.model.url() + '/related_users',
        method: "GET",
        success: function( data ) {
          self.el.html(data);
        }
      });
    }
  }
});
