window.RelatedUsersView = Backbone.View.extend({

  el: $("#left-column .related-users"),
  
  initialize: function() { 
  },

  reInit: function(opts) {
    if (!this.model || this.model.id !== opts.model.id){
      this.model = opts.model;
    }
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
