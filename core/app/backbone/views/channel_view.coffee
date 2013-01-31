class window.ChannelView extends Backbone.Marionette.Layout
  template: 'channels/channel'

  regions:
    factList: '#facts_for_channel'
    subChannelsRegion: '.js-subchannels-region'
    addToChannelRegion: '.add-to-channel-region'
    creatorProfileRegion: ".created_by_region"

  initialize: (opts) ->
    @on 'render', =>
      @renderSubChannels()
      if @model.get('followable?')
        @addToChannelRegion.show new AddChannelToChannelsButtonView(model: @model)
      @creatorProfileRegion.show new UserWithAuthorityBox
        model: @model.user(),
        authority: @model.get('created_by_authority')

  renderSubChannels: ->
    if @model.get('inspectable?')
      @subChannelsRegion.show new SubchannelsView
        collection: @model.subchannels()
        model: @model

  onRender: ->
    @showChannelFacts()


  showChannelFacts: -> @showFacts @channelFacts()
  showTopicFacts: -> @showFacts @topicFacts()

  showFacts: (facts) ->
    @factList.show new FactsView
      model: @model
      collection: facts

  channelFacts: -> new ChannelFacts([], channel: @model)

  topicFacts: -> @model.topic().facts()

class window.ChannelActivitiesView extends Backbone.Marionette.Layout
  template: 'channels/channel_activities'

  regions:
    activityList: '#activity_for_channel'

  events:
    "click .js-activities-refresh": "refresh"

  initialize: ->
    @bindTo @collection, 'change_count', @update_count, @
    @start_updating_count()
    @on 'attached', @start_updating_count, @
    @on 'detached', @stop_updating_count, @

  onClose: -> @stop_updating_count()

  stop_updating_count: ->
    if @running
      clearTimeout(@timer)
      @running = false

  _restart_updating_count: ->
    if @running
      @running=false
      @start_updating_count()

  start_updating_count: ->
    unless @running
      @running = true
      @timer = setTimeout =>
        @fetch_activity_count
          success: => @_restart_updating_count()
          error: => @_restart_updating_count()
      ,Factlink.Timeout.stream_refresh

  fetch_activity_count: (args...)->
    @collection.fetch_count(args...)

  update_count: ->
    @$('.activities-more .unread_count').html(@collection.get_new_activity_count());
    @$('.activities-more').toggle(@collection.get_new_activity_count() > 0);

  refresh: (e) ->
    @collection.fetch()
    e.preventDefault()
    e.stopPropagation()

  getActivitiesView: ->
    new ActivitiesView collection: @collection, disableEmptyView: @options.disableEmptyView

  onRender: ->
    @activityList.show @getActivitiesView()
