window.RelatedUsersView = Backbone.View.extend({

  initialize: function() {
    this.setElement($("#left-column .related-users"));
  },

  reInit: function(opts) {
    if (!this.model || this.model.id !== opts.model.id){
      this.model = opts.model;
    }
    return this;
  },

  render: function() {
    var self = this;

    if ( this.model.get('topic_url')) {
      console.info(this.model.get('topic'))
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
