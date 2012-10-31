#= require ./channel_item_view.js

class window.ChannelsView extends Backbone.Marionette.CompositeView
  template: 'channels/channel_list'
  itemView: ChannelItemView
