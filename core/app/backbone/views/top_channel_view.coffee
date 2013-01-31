class window.TopChannelItemView extends Backbone.Marionette.Layout
  template: 'channels/topchannel'
  tagName: 'li'
  className: 'top-channels-channel'

  regions:
    add_to_channel_button_region: '.js-add-to-channel-button-region'


  onRender: ->
    suggested_topics        = new SuggestedTopics([@model.topic()])

    add_back_button = new AddChannelToChannelsButtonView
                                model: @model
                                suggested_topics: suggested_topics

    @add_to_channel_button_region.show add_back_button

class window.TopChannelView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_channels"
  className: "top-channel-container"
  itemView: TopChannelItemView
  itemViewContainer: ".top-channels"
  events:
    "click a.top-channels-show-more": "showMoreOn"
    "click a.top-channels-show-less": "showMoreOff"

  showMoreOn:  ->
    @$el.addClass 'showMore'

  showMoreOff: -> @$el.removeClass 'showMore'

  showEmptyView: ->
      @$(".top-channels").hide()
      @$(".no-channels").show()

  closeEmptyView: ->
      @$(".no-channels").hide()
      @$(".top-channels").show()

  onCompositeCollectionRendered: ->
    @$(".top-channels-show-more").hide() if @collection.length < 6
