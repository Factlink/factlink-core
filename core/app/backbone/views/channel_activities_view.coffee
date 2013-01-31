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
