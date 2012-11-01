#= require ../channels_view

class window.EditableChannelsView extends ChannelListView
  template: "channels/_single_editable_menu_items"

  itemView: EditableChannelItemView

  className: 'tourChannels'

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()
