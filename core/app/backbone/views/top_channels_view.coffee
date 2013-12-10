class TopChannelView extends Backbone.Marionette.Layout
  template: 'channels/topchannel'
  className: 'top-channels-channel'

  templateHelpers: =>
    position: @options.position
    topic_link: @model.topic().url()

class TopChannelsEmptyView extends Backbone.Marionette.ItemView
  template: 'users/profile/top_channels_empty'

  templateHelpers: =>
    topics: Factlink.Global.t.topics.capitalize()
    username: @options.user.get('username')
    is_current_user: @options.user.is_current_user()

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

  initialize: ->
    @listenTo @collection, "add remove reset", @toggleShowMore

  templateHelpers: =>
    topics: Factlink.Global.t.topics.capitalize()

  itemViewOptions: (model) ->
    position: @collection.indexOf(model) + 1
    collection: @collection # for the emptyView
    user: @options.user

  showMoreOn:  -> @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  onRender: ->
    @toggleShowMore()

  toggleShowMore: ->
    @ui.showMoreLessButtons.toggle (@collection.length > 5)
