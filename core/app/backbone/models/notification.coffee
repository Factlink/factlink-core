class window.Notification extends Backbone.Model
  channel: ->
    return @_cached_channel if @cached_channel?
    return null unless @channel_id()

    @_cached_channel = new Channel(id: @channel_id())
    @_cached_channel.fetch()
    @_cached_channel

  channel_id: -> @get('activity').to_channel_id

