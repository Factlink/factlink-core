class window.ArgumentVotes extends Backbone.Model
  defaults:
    believes: 0
    disbelieves: 0

  isNew: -> @_argument.isNew()

  initialize: (attributes, options) ->
    @_argument = options.argument

  url: ->
    @_argument.url() + '/opinion'

  setCurrentUserOpinion: (newOpinion) ->
    previousOpinion = @get('current_user_opinion')
    @set previousOpinion, @get(previousOpinion)-1 if previousOpinion != 'no_vote'
    @set newOpinion, @get(newOpinion)+1 if newOpinion != 'no_vote'
    @set 'current_user_opinion', newOpinion

  saveCurrentUserOpinion: (opinion_type) ->
    @previous_opinion_type = @get('current_user_opinion')

    @setCurrentUserOpinion opinion_type
    @save {},
      success: =>
        mp_track "Argument: Opinionate", url: @url(), opinion: opinion_type
      error: =>
        @setCurrentUserOpinion @previous_opinion_type

  relevance: -> @get('believes') - @get('disbelieves')
