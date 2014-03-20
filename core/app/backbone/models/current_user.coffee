#= require ./user

class window.CurrentUser extends User
  defaults:
    features: []

  url: -> '/api/beta/current_user'

  parse: (response) ->
    # Don't merge but override (this triggers some events, but who cares)
    @clear silent: true
    response

  change_password: (attributes, success=->) ->
    Backbone.ajax
      method: 'put'
      url: @url() + '/change_password.json'
      data: attributes
      success: ->
        window.parent.FactlinkApp.NotificationCenter.success 'Your password has been changed!'
        success()
      error: ->
        window.parent.FactlinkApp.NotificationCenter.error 'Could not change your password, please try again.'
