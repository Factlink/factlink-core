class window.ChannelActivities extends Backbone.Collection
  model: Activity

  initialize: (models, opts) ->
    @channel = opts.channel;
    @_count = new ChannelActivityCount {}, channel_activity_collection: @
    @_count.bind 'change', @update_count, @
    @on 'reset add remove', @setLatestTimestamp, @
    @setLatestTimestamp()

  update_count: ->
    @trigger 'change_count'

  get_new_activity_count: ->
    if @_count.get('timestamp') == @latest_timestamp()
      @_count.count()
    else
      0

  fetch_count: (args...)->
    @_count.fetch(args...)

  setLatestTimestamp: ->
    timestamp = @latest_timestamp()
    @_count.setTimestamp timestamp if timestamp

  url: -> '/' + this.channel.get('created_by').username + '/channels/' + this.channel.get('id') + '/activities';
  link: -> @url()

  latest_timestamp: -> @first()?.get('timestamp')

_.extend(ChannelActivities.prototype, AutoloadCollectionOnTimestamp);

class ChannelActivityCount extends Backbone.Model
  initialize: (attributes, options) ->
    @collection_url = options.channel_activity_collection.url()
    @set timestamp: (@get('timestamp') || 0)

  url: -> @collection_url + "/count.json?timestamp=#{@get('timestamp')}"

  fetch: (args...) ->
    super(args...)

  parse: (response)->
    response = super(response)
    if response.timestamp == @get('timestamp')
      response
    else
      {count: 0}

  count: ->
    @get('count') || 0

  setTimestamp: (timestamp) ->
    @set
      timestamp: timestamp
      count: 0
