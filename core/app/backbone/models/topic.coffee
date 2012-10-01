class window.Topic extends Backbone.Model
  newChannelForUser: (user) ->
    new Channel
      title: this.get 'title'
      slug_title: this.get 'slug_title'
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
        error:   (m,r)-> options.error?(m,r)
      )

  existingChannelFor: (user)->
    user.channels.getBySlugTitle(@get 'slug_title')