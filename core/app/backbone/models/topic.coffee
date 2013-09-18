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

  urlRoot: ->
    '/t' unless @collection?

  favourite: ->
    currentUser.favourite_topics.create @,
      error: =>
        currentUser.favourite_topics.remove @
        @set 'favouritours_count', @get('favouritours_count')-1

    @set 'favouritours_count', @get('favouritours_count')+1
    currentUser.favourite_topics.sort()

  unfavourite: ->
    currentUser.favourite_topics.get(@).destroy
      error: =>
        currentUser.favourite_topics.add @
        @set 'favouritours_count', @get('favouritours_count')+1

    @set 'favouritours_count', @get('favouritours_count')-1

  toJSON: ->
    _.extend super(),
      link: '/t/' + @get('slug_title')
