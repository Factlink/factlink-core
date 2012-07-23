#= require ../channels_view

class window.EditableChannelsView extends ChannelsView
  template: "channels/_single_editable_menu_items"

  itemView: EditableChannelItemView

  className: 'tourChannels'

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()