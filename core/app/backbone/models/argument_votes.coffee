class window.ArgumentVotes extends Backbone.Model
  defaults:
    believes: 0
    disbelieves: 0

  isNew: -> false

  initialize: (attributes, options) ->
    @_argument = options.argument

  url: ->
    @_argument.url() + '/opinion'

  setCurrentUserOpinion: (newValue) ->
    previousValue = @get('current_user_opinion')
    @set previousValue, @get(previousValue)-1 if previousValue != 'no_vote'
    @set newValue, @get(newValue)+1 if newValue != 'no_vote'
    @set 'current_user_opinion', newValue

  saveCurrentUserOpinion: (opinion_type) ->
    @previous_opinion_type = @get('current_user_opinion')

    @setCurrentUserOpinion opinion_type
    @save {},
      success: =>
        mp_track "Argument: Opinionate", url: @url(), opinion: opinion_type
      error: =>
        @setCurrentUserOpinion @previous_opinion_type

  relevance: -> @get('believes') - @get('disbelieves')
