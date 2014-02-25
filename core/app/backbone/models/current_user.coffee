#= require ./user

class window.CurrentUser extends User
  url: -> '/api/beta/current_user'

  initialize: ->
    super

    @on 'change:features', -> Factlink.setFeatures @get('features')
