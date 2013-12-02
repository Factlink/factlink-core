fetched = (obj) ->
  obj.fetch()
  obj

class window.Channel extends Backbone.Model
  initialize: (opts) ->
    @on "activate", @setActive
    @on "deactivate", @setNotActive

  setActive:    -> @_isActive = true
  setNotActive: -> @_isActive = false
  isActive:     -> @_isActive

  user: -> new User(@get("created_by"))

  cached: (field, retrieval) ->
    @cache ||= {}
    @cache[field] = (@cache[field] || retrieval())

  topic: ->
    new Topic
      slug_title: @get 'slug_title'
      title: @get 'title'

  facts: -> new ChannelFacts [], channel: this

  topicUrl: -> "/t/#{@get('slug_title')}"

  url: ->
    if @collection
      Backbone.Model::url.apply this, arguments
    else
      @normal_url()

  normal_url: ->
    "/" + @getUsername() + "/channels/" + @id

  getUsername: ->
    @get("created_by")?.username ? @get("username")

  toJSON: ->
    _.extend super(),
      link: @normal_url()
