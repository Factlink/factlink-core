class window.Vote extends Backbone.Model

  user: ->
    @_user ?= new User @get('user')
