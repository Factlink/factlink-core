class window.RelatedChannelsView extends Backbone.Marionette.CompositeView
  template: "channels/_related_channels",

  itemViewContainer: "ul",

  itemView: RelatedChannelView

  itemViewOptions: => addToCollection : @options.addToCollection

  showEmptyView: => this.$el.hide()
  closeEmptyView: => this.$el.show()