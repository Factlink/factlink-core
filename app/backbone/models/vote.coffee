class window.Vote extends Backbone.Model
  idAttribute: 'username'

  user: ->
    @_user ?= new User @get('user')
