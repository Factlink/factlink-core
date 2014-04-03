class window.CommentTally extends Backbone.Model
  defaults:
    believes: 0
    disbelieves: 0

  isNew: -> @_comment.isNew()

  initialize: (attributes, options) ->
    @_comment = options.comment

    @_comment.on 'change:tally', =>
      @set @_comment.get('tally')

  url: ->
    @_comment.url() + '/opinion'

  _setCurrentUserOpinion: (newOpinion) ->
    previousOpinion = @get('current_user_opinion')
    @set previousOpinion, @get(previousOpinion)-1 if previousOpinion != 'no_vote'
    @set newOpinion, @get(newOpinion)+1 if newOpinion != 'no_vote'
    @set 'current_user_opinion', newOpinion

  _saveCurrentUserOpinion: (opinion_type) ->
    @previous_opinion_type = @get('current_user_opinion')
    return if @previous_opinion_type == opinion_type

    @_setCurrentUserOpinion opinion_type
    @save {},
      success: =>
        mp_track "Comment: Vote", url: @url(), opinion: opinion_type
      error: =>
        @_setCurrentUserOpinion @previous_opinion_type

  clickCurrentUserOpinion: (opinion_type) ->
    if @get('current_user_opinion') == opinion_type
      @_saveCurrentUserOpinion 'no_vote'
    else
      @_saveCurrentUserOpinion opinion_type


  relevance: -> @get('believes') - @get('disbelieves')
