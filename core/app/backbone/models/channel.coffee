class window.Channel extends Backbone.Model
  user: -> new User(@get("created_by"))

  topic: ->
    new Topic
      slug_title: @get 'slug_title'
      title: @get 'title'

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
