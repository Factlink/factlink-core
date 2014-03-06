#= require ./user

class window.CurrentUser extends User
  defaults:
    features: []

  url: -> '/api/beta/current_user'

  parse: (response) ->
    # Don't merge but override (this triggers some events, but who cares)
    @clear silent: true
    return response
