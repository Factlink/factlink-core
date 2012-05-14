window.RelatedUsersView = Backbone.View.extend({

  reInit: function(opts) {
    if (!this.model || this.model.id !== opts.model.id){
      this.model = opts.model;
    }
    return this;
  },

  render: function() {
    var self = this;

    if ( this.model.get('topic_url')) {
      $.ajax({
        url: this.model.get('topic_url') + '/related_users',
        method: "GET",
        success: function( data ) {
          self.$el.html(data);
        }
      });
    } else {
      self.$el.html([]);
    }
  }
});
