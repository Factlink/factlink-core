class window.RelatedChannelsView extends Backbone.Marionette.CompositeView
  template: "channels/_related_channels",

  itemViewContainer: "ul",

  itemView: RelatedChannelView

  itemViewOptions: => addToCollection : @addToCollection

  templateHelpers: =>
    is_mine: this.model.get('created_by').username == currentUser.get('username')

  initialize: (options) ->
    @addToCollection = this.model.subchannels()
    @collection =  collectionDifference(new ChannelList, 'id', this.model.relatedChannels(), this.addToCollection, [@model]);

  showEmptyView: => this.$el.hide()
  closeEmptyView: => this.$el.show()
