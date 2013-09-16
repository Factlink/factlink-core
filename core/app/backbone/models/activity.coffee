class window.Activity extends Backbone.Model

  user: ->
    @_user ?= new User @get('user')
