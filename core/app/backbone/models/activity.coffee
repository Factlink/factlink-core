class window.Activity extends Backbone.Model
  getActivity: () ->
    new Activity(this)

  user: ->
    @_user ?= new User @get('user')
