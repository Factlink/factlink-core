#= require ./user

class window.CurrentUser extends User
  defaults:
    features: []

  url: -> '/api/beta/current_user'
