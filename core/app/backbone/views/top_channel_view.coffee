class window.TopChannelItemView extends Backbone.Marionette.ItemView
  template: 'channels/topchannel'
  tagName: 'li'

class window.TopChannelView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_channels"
  className: "top-channel-container"
  itemView: TopChannelItemView
  itemViewContainer: ".top-channels ol"
  events:
    "click a.show-more": "showMoreOn"
    "click a.show-less": "showMoreOff"

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

  onRender: ->
    @$(".top-channels .show-more").hide() if @collection.length < 6
