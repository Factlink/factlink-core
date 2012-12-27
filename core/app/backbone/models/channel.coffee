fetched = (obj) ->
  obj.fetch()
  obj

class window.Channel extends Backbone.Model
  initialize: (opts) ->
    @on "activate", @setActive
    @on "deactivate", @setNotActive

  setActive: ->
    @isActive = true

  setNotActive: ->
    @isActive = false

  user: -> new User(@get("created_by"))

  cached: (field, retrieval) ->
    @cache ||= {}
    @cache[field] = (@cache[field] || retrieval())

  subchannels: ->
    @cached 'subchannels', => fetched(new SubchannelList(channel: this))

  relatedChannels: ->
    @cached 'relatedchannels', => fetched(new RelatedChannels [], forChannel: this)

  lastAddedFactAsActivity: ->
    @cached 'lastFactAsActivity', =>
      console.info('creating new lastfactactivity')
      new LastFactActivity(channel: this)

  topic: ->
    new Topic
      slug_title: @get 'slug_title'
      title: @get 'title'

  facts: ->
    new ChannelFacts [],
      channel: this

  topicUrl: -> "/t/#{@get('slug_title')}"

  getOwnContainingChannels: (eventbinder) ->
    containing_channel_ids = @get("containing_channel_ids") ? []

    col = new OwnChannelCollection currentUser.channels.channelArrayForIds(containing_channel_ids)

    eventbinder.bindTo currentUser.channels, 'reset', ->
      col.reset currentUser.channels.channelArrayForIds(containing_channel_ids)

    col

  url: ->
    if @collection
      Backbone.Model::url.apply this, arguments
    else
      @normal_url()

  normal_url: ->
    "/" + @getUsername() + "/channels/" + @id

  getUsername: ->
    @get("created_by")?.username ? @get("username")

  addToChannel: (sub_channel, options={}) ->
    @_changeFollowingChannel('add', sub_channel, options)

  removeFromChannel: (sub_channel, options={}) ->
    @_changeFollowingChannel('remove', sub_channel, options)

  _changeFollowingChannel: (action, sub_channel, options) ->
    changeUrl = "#{@normal_url()}/subchannels/#{action}/#{sub_channel.id}"

    $.ajax
      url: changeUrl
      type: 'post'
      error: -> options.error?()
      success: =>
        mp_track "Channel: #{action} subchannel",
          channel_id: @id
          subchannel_id: sub_channel.id

        options.success?()
