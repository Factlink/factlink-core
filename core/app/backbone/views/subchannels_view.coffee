class window.SubchannelsView extends Backbone.Factlink.CompositeView
  tagName: "div"
  id: "contained-channels"
  template: "channels/subchannels"
  itemView: SubchannelItemView
  itemViewContainer: "#contained-channel-list"

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()