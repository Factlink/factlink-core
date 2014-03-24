class window.UserPassword extends Backbone.Model
  defaults:
    current_password: ''
    password: ''
    password_confirmation: ''

  initialize: (attributes, options) ->
    @_user = options.user

  url: -> @_user.url() + '/password'
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

    errors.length && _.extend({}, errors...)
