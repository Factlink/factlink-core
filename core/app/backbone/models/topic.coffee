class window.Topic extends Backbone.Model
  newChannelForUser: (user) ->
    new Channel
      title: this.get 'title'
      slug_title: this.get 'slug_title'
      username: user.get 'username'