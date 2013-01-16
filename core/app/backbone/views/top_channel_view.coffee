class window.TopChannelItemView extends Backbone.Marionette.ItemView
  template: 'channels/topchannel'
  tagName: 'li'
  className: 'top-channels-channel'

class window.TopChannelView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_channels"
  className: "top-channel-container"
  itemView: TopChannelItemView
  itemViewContainer: ".top-channels"
  events:
    "click a.top-channels-show-more": "showMoreOn"
    "click a.top-channels-show-less": "showMoreOff"

  showMoreOn:  ->
    console.info @$el
    @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  showEmptyView: ->
      @$(".top-channels").hide()
      @$(".no-channels").show()

  closeEmptyView: ->
      @$(".no-channels").hide()
      @$(".top-channels").show()

  onRenderCollection: ->
    @$(".top-channels .show-more").hide() if @collection.length < 6
