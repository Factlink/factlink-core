class window.OpinionatersEvidence extends Backbone.Model

  opinionaters: ->
    unless @_opinionaters?
      @_opinionaters = new Users @get('users')
      @on 'change', => @_opinionaters.reset @get('users')
    @_opinionaters
