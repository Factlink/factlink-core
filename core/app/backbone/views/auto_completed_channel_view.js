window.AutoCompletedChannelView = Backbone.View.extend({
  tagName: "li",

  tmpl: HoganTemplates["channels/_auto_completed_channel"],

  initialize: function () {
    this.queryRegex = new RegExp(this.options.query, "gi");
  },

  render: function () {
    var title = this.model.get('title');
    var highlightedTitle = title.replace(this.queryRegex, "<em>$&</em>");

    var context = _.extend(this.model.toJSON(), {
      highlightedTitle: highlightedTitle
    });

    this.$el.html( this.tmpl.render( context ) );

    return this;
  }
});
