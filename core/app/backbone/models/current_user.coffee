#= require ./user

class CurrentUserPassword extends Backbone.Model
  defaults:
    current_password: ''
    password: ''
    password_confirmation: ''

  url: -> '/api/beta/current_user/password'
  isNew: -> false

  # Weirdly, this is not default behaviour
  clear: ->
    @set @defaults

  validate: (attributes, options) ->
    if attributes.current_password.length == 0
      return 'No current password'
    if attributes.password.length < 6
      return 'New password to short' # seems to be enforced by Devise
    if attributes.password_confirmation != attributes.password
      return 'Confirmation does not match'
    
    null


class window.CurrentUser extends User
  defaults:
    features: []

  url: -> '/api/beta/current_user'

  parse: (response) ->
    # Don't merge but override (this triggers some events, but who cares)
    @clear silent: true
    response

  password: -> @_password ?= new CurrentUserPassword
