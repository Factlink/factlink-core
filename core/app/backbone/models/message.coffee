class window.Message extends Backbone.Model
  defaults:
    time_ago: 'just now'

  sender: -> @_sender ?= new User(@get('sender'))
