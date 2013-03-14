class window.TopChannelItemView extends Backbone.Marionette.Layout
  template: 'channels/topchannel'
  className: 'top-channels-channel'

  regions:
    add_to_channel_button_region: '.js-add-to-channel-button-region'

  templateHelpers: =>
    position: @options.position

  onRender: ->
    @renderAddBackButton() unless @model.user().is_current_user()

  renderAddBackButton: ->
    add_back_button = new FollowChannelButtonView(model: @model)
    @add_to_channel_button_region.show add_back_button

class window.TopChannelView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_channels"
  className: "top-channel-container"
  itemView: TopChannelItemView
  itemViewContainer: ".top-channels"
  events:
    "click a.top-channels-show-more": "showMoreOn"
    "click a.top-channels-show-less": "showMoreOff"

  itemViewOptions: (model) ->
    position: @collection.indexOf(model) + 1

  showMoreOn:  -> @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  showEmptyView: ->
      @$(".top-channels").hide()
      @$(".no-channels").show()

  closeEmptyView: ->
      @$(".no-channels").hide()
      @$(".top-channels").show()

  onCompositeCollectionRendered: ->
    if @collection.length < 6
      @showMoreOn()
    else
      @showMoreOff()

