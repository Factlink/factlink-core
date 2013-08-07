fetched = (obj) ->
  obj.fetch()
  obj

class window.Channel extends Backbone.Model
  initialize: (opts) ->
    @on "activate", @setActive
    @on "deactivate", @setNotActive

  setActive: ->
    @_isActive = true

  setNotActive: ->
    @_isActive = false

  isActive: -> @_isActive

  user: -> new User(@get("created_by"))

  cached: (field, retrieval) ->
    @cache ||= {}
    @cache[field] = (@cache[field] || retrieval())

  subchannels: ->
    @cached 'subchannels', => fetched(new Subchannels([], channel: this))

  topic: ->
    new Topic
      slug_title: @get 'slug_title'
      title: @get 'title'

  facts: ->
    new ChannelFacts [],
      channel: this

  topicUrl: -> "/t/#{@get('slug_title')}"

  getOwnContainingChannels: (eventAggregator) ->
    containing_channel_ids = @get("containing_channel_ids") ? []

    col = new OwnChannelCollection currentUser.channels.channelArrayForIds(containing_channel_ids)

    eventAggregator.listenTo currentUser.channels, 'add remove reset', ->
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

    Backbone.ajax
      url: changeUrl
      type: 'post'
      error: -> options.error?()
      success: =>
        mp_track "Channel: #{action} subchannel",
          channel_id: @id
          subchannel_id: sub_channel.id

        options.success?()

  is_mine: -> @user().is_current_user()

  toJSON: ->
    _.extend super(),
      is_mine: @is_mine()

  follow: ->
    followUrl = "#{@normal_url()}/follow"
    @set('followed?', true)
    Backbone.ajax
      url: followUrl
      type: 'post'
      error: => @set('followed?', false)

  unfollow: ->
    unfollowUrl = "#{@normal_url()}/unfollow"
    @set('followed?', false)
    Backbone.ajax
      url: unfollowUrl
      type: 'post'
      error: => @set('followed?', true)
