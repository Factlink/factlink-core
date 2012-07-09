class window.RelatedChannelsView extends Backbone.Marionette.CompositeView
  template: "channels/_related_channels",

  itemViewContainer: "ul",

  itemView: RelatedChannelView

  itemViewOptions: => addToCollection : @options.addToCollection

  templateHelpers: =>
    is_mine: this.model.get('created_by').username == currentUser.get('username')

  initialize: (options) ->
    @collection =  collectionDifference(ChannelList, options.collection, options.addToCollection, new ChannelList([@model]));

  showEmptyView: => this.$el.hide()
  closeEmptyView: => this.$el.show()