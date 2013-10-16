class window.SubchannelsView extends Backbone.Factlink.CompositeView
  id: "contained-channels"
  template: "channels/subchannels"
  itemView: SubchannelItemView
  itemViewContainer: "#contained-channel-list"

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()

  templateHelpers:
    header: Factlink.Global.t.following.capitalize()
