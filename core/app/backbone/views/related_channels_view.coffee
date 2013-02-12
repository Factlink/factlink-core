class window.RelatedChannelsView extends Backbone.Marionette.CompositeView
  className: "related-channels-for-channel"

  template: "channels/related_channels",

  itemViewContainer: "ul",

  itemView: RelatedChannelView

  itemViewOptions: => addToCollection : @addToCollection

  templateHelpers: =>
    is_mine: @model.get('created_by').username == currentUser.get('username')

  initialize: (options) ->
    @addToCollection = @model.subchannels()
    @collection =  collectionDifference(new ChannelList, 'id', @model.relatedChannels(), @addToCollection, [@model]);

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()
