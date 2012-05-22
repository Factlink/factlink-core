window.AutoCompletedAddedChannelView = Backbone.View.extend({
  tagName: "li",

  events: {
    "click a": "removeFromRootView"
  },

  removeFromRootView: function () {
    this.options.rootView.removeAddedChannel(this.model.id);
  },

  tmpl: HoganTemplates["channels/_auto_completed_added"],

  render: function () {
    this.$el.html( this.tmpl.render( this.model.toJSON() ) );

    return this;
  }
});
