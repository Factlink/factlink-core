window.RelatedUsersView = Backbone.View.extend({
  render: function() {
    if ( this.model.get('topic_url')) {
      $.ajax({
        url: this.model.get('topic_url') + '/related_users',
        method: "GET",
        success: _.bind(function( data ) {this.$el.html(data);},this)
      });
    } else {
      this.$el.html([]);
    }
  }
});
