class window.Topic extends Backbone.Model
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
      ch.save({},
        success: (m,r)-> options.success?(m,r)
        error:   (m,r)->
          user.channels.remove(ch)
          options.error?(m,r)
      )

  existingChannelFor: (user)->
    user.channels.getBySlugTitle(@get 'slug_title')
