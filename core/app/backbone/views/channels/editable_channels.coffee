#= require ../channels_view

class window.EditableChannelsView extends Backbone.Marionette.CompositeView
  template: "channels/single_editable_menu_items"

  itemView: EditableChannelItemView
  itemViewContainer: '.channel-listing'

  className: 'tour-channel-suggestions white-well'

  showEmptyView: => @$el.hide()
  closeEmptyView: => @$el.show()

  appendHtml: (collectionView, itemView, index) ->
    collectionView.$(@itemViewContainer).append(itemView.el);

