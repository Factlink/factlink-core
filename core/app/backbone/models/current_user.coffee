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
    errors = _.compact [
      if attributes.current_password.length == 0
        current_password: '*'

      if attributes.password.length == 0
        password: '*'
      else if attributes.password.length < 6 # seems to be enforced by Devis
        password: 'too short'

      if attributes.password_confirmation.length == 0
        password_confirmation: '*'
      else if attributes.password_confirmation != attributes.password
        password_confirmation: 'does not match'
    ]

    console.info errors

    errors.length && _.extend({}, errors...)


class window.CurrentUser extends User
  defaults:
    features: []

  url: -> '/api/beta/current_user'

  parse: (response) ->
    # Don't merge but override (this triggers some events, but who cares)
    @clear silent: true
    response

  password: -> @_password ?= new CurrentUserPassword
