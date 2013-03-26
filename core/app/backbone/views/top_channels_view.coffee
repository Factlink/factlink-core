class TopChannelView extends Backbone.Marionette.Layout
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

class TopChannelsEmptyView extends Backbone.Marionette.ItemView
  template: 'users/profile/top_channels_empty'

class TopChannelsEmptyLoadingView extends Backbone.Factlink.EmptyLoadingView
  emptyView: TopChannelsEmptyView

class window.TopChannelsView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_channels"
  className: "top-channel-container"
  itemView: TopChannelView
  emptyView: TopChannelsEmptyLoadingView
  itemViewContainer: ".top-channels"
  events:
    "click a.top-channels-show-more": "showMoreOn"
    "click a.top-channels-show-less": "showMoreOff"

  ui:
    showMoreLessButtons: '.js-show-more-less-buttons'

  itemViewOptions: (model) ->
    position: @collection.indexOf(model) + 1
    collection: @options.originalCollection # for the emptyView

  showMoreOn:  -> @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  onCompositeCollectionRendered: ->
    @ui.showMoreLessButtons.toggle @collection.length > 5
