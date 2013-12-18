class window.OpinionatersEvidence extends Backbone.Model
  defaults:
    users: []

  idAttribute: 'type'

  opinionaters: ->
    unless @_opinionaters?
      @_opinionaters = new Users @get('users')
      @on 'change', => @_opinionaters.reset @get('users')
    @_opinionaters
