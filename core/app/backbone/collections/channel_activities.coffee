class window.ChannelActivities extends Backbone.Collection
  model: Activity

  initialize: (models, opts) ->
    @channel = opts.channel;
    @_count = new ChannelActivityCount {}, channel_activity_collection: @
    @_count.bind 'change', @update_count, @
    @on 'reset add remove', @onReset, @

  update_count: ->
    @trigger 'change_count'

  get_new_activity_count: ->
    if @_count.get('timestamp') == @latest_timestamp()
      @_count.count()
    else
      0

  fetch_count: (args...)->
    @_count.fetch(args...)

  onReset: ->
    @_count.setTimestamp @latest_timestamp()

  url: -> '/' + this.channel.get('created_by').username + '/channels/' + this.channel.get('id') + '/activities';
  link: -> @url()

  latest_timestamp: -> @first()?.get('timestamp')

_.extend(ChannelActivities.prototype, AutoloadCollectionOnTimestamp);

class ChannelActivityCount extends Backbone.Model
  initialize: (attributes, options) ->
    @collection_url = options.channel_activity_collection.url()

  url: -> @collection_url + "/count?timestamp=#{@get('timestamp')}"

  count: ->
    @get('count') || 0

  setTimestamp: (timestamp) ->
    @set(timestamp: timestamp)
    @set(count: null)
