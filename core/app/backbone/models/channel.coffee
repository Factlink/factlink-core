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

  getOwnContainingChannels: ->
    containingChannels = @get("containing_channel_ids")
    ret = []
    currentUser.channels.each (ch) ->
      if _.indexOf(containingChannels, ch.id) isnt -1
        ret.push ch.clone()

    new OwnChannelCollection ret

  url: ->
    if @collection
      Backbone.Model::url.apply this, arguments
    else
      @normal_url()

  normal_url: ->
    "/" + @getUsername() + "/channels/" + @get("id")

  getUsername: ->
    @get("created_by")?.username ? @get("username")
