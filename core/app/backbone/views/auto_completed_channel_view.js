window.AutoCompletedChannelView = Backbone.View.extend({
  tagName: "li",

  tmpl: HoganTemplates["channels/_auto_completed_channel"],

  render: function () {
    console.info( this.options.query );
    var highlightedTitle = this.model.get('title');

    var context = _.extend(this.model.toJSON(), {

    });

    this.$el.html( this.tmpl.render( context ) );

    return this;
  }
});
