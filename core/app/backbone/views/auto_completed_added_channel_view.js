window.AutoCompletedAddedChannelView = Backbone.View.extend({
  tagName: "li",

  tmpl: HoganTemplates["channels/_auto_completed_added"],

  initialize: function () {
    console.info( this.model );
  },

  render: function () {
    this.$el.html( this.tmpl.render( this.model.toJSON() ) );

    return this;
  }
});
