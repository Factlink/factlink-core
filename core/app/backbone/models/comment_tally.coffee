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

  # When signing in using the ReactSigninPopover after voting a race condition occurs
  # between the get request of the user associated comments and the put request of the vote.
  # when the put request is earlier:
  # _setOpinionAgainAfterCollectionFetch checks whether the backbone collection is loading after setting,
  # if the get request is still busy, and redos the users action after the get request is completed / synced.
  # when the get request is earlier:
  # _setOpinionAgainAfterCollectionFetch sets the currentUserOpinion directly after successful processing of the put request
  # to override the data of the get request
  _setOpinionAgainAfterCollectionFetch: (opinion_type) ->
    @_setCurrentUserOpinion opinion_type
    if @_comment.collection.loading()
      @_comment.collection.once 'sync', => @_setCurrentUserOpinion opinion_type

  saveCurrentUserOpinion: (opinion_type) ->
    @previous_opinion_type = @get('current_user_opinion')
    return if @previous_opinion_type == opinion_type

    @_setCurrentUserOpinion opinion_type
    @save {},
      success: =>
        @_setOpinionAgainAfterCollectionFetch opinion_type
      error: =>
        @_setCurrentUserOpinion @previous_opinion_type

  relevance: -> @get('believes') - @get('disbelieves')
