#= require ./user

class window.CurrentUser extends User
  url: -> '/api/beta/current_user'
