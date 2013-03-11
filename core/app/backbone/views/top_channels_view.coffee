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
    suggested_topics = new SuggestedTopics([@model.topic()])
    add_back_button  = new AddChannelToChannelsButtonView
                                model: @model
                                suggested_topics: suggested_topics

    @add_to_channel_button_region.show add_back_button

class TopChannelsEmptyView extends Backbone.Marionette.ItemView
  template: 'users/profile/top_channels_empty'

  initialize: ->
    @bindTo @collection, 'before:fetch reset', @render, @

  onRender: ->
    if @collection.loading
      @$('.loading').show()
      @$('.empty').hide()
    else
      @$('.loading').hide()
      @$('.empty').show()

class window.TopChannelsView extends Backbone.Marionette.CompositeView
  template: "users/profile/top_channels"
  className: "top-channel-container"
  itemView: TopChannelView
  emptyView: TopChannelsEmptyView
  itemViewContainer: ".top-channels"
  events:
    "click a.top-channels-show-more": "showMoreOn"
    "click a.top-channels-show-less": "showMoreOff"

  itemViewOptions: (model) ->
    position: @collection.indexOf(model) + 1
    collection: @collection

  showMoreOn:  -> @$el.addClass 'showMore'
  showMoreOff: -> @$el.removeClass 'showMore'

  onCompositeCollectionRendered: ->
    if @collection.length < 6
      @showMoreOn()
    else
      @showMoreOff()

