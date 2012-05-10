window.AutoCompletedChannelView = Backbone.View.extend({
  tagName: "li",
  initialize: function () {
    this.useTemplate("channels", "_auto_completed_channel");
  },

  render: function () {
    console.info( this.options.query );
    var highlightedTitle = this.model.get('title');

    var context = _.extend(this.model.toJSON(), {

    });

    this.$el.html( Mustache.to_html( this.tmpl, context ) );

    return this;
  }
});
