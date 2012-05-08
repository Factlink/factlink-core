window.AutoCompletedChannelView = Backbone.View.extend({
  tagName: "li",
  initialize: function () {
    this.useTemplate("channels", "_auto_completed_channel");
  },

  render: function () {
    this.$el.html( Mustache.to_html( this.tmpl, this.model.toJSON() ) );

    return this;
  }
});
