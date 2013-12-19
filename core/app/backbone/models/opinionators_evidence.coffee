class window.OpinionatorsEvidence extends Backbone.Model
  defaults:
    users: []

  idAttribute: 'type'

  opinionators: ->
    unless @_opinionators?
      @_opinionators = new Users @get('users')
      @on 'change', => @_opinionators.reset @get('users')
    @_opinionators
