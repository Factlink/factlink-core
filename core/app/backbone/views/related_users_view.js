window.RelatedUsersView = Backbone.View.extend({
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
