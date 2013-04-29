class window.Topic extends Backbone.Model

  idAttribute: 'slug_title'

  isActive: -> @collection.isActive(@)

  newChannelForUser: (user) ->
    new Channel
      title: @get 'title'
      slug_title: @get 'slug_title'
      username: user.get 'username'

  withCurrentOrCreatedChannelFor: (user, options)->
    if ch = @existingChannelFor(user)
      options.success?(ch)
    else
      ch = @newChannelForUser(user)
      user.channels.add(ch)
      console.info "saving channel #{ch.get 'title'} to #{ch.url()}"
      ch.save {},
        success: (m,r)-> options.success?(m,r)
        error:   (m,r)->
          user.channels.remove(ch)
          options.error?(m,r)

  existingChannelFor: (user)->
    user.channels.getBySlugTitle(@get 'slug_title')

  facts: -> new TopicFacts([], topic: @)

  # TODO: check if we can refactor this to use idAttribute and baseUrl
  url: ->
    if @collection?
      @collection.url() + '/' + @get('slug_title')
    else
      @canonicalUrl()

  canonicalUrl: ->
    '/t/' + @get('slug_title')

  favourite: ->
    currentUser.favourite_topics.create( @attributes )

  unfavourite: ->
    currentUser.favourite_topics.remove( @ )

  toJSON: ->
    _.extend super(),
      link: @canonicalUrl()
