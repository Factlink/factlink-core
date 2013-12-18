class window.OpinionatersEvidence extends Backbone.Model

  opinionaters: ->
    @_opinionaters ?= new Users @get('users')
