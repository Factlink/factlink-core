class window.Activity extends Backbone.Model
  getActivity: () ->
    new Activity(this)

  user: ->
    new User(this.get('user'))
