class window.Votes extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @_fact_id = options.fact.id

  url: ->
    "/facts/#{@_fact_id}/opinionators"

  opinion_for_current_user:  ->
    return 'no_vote' unless window.currentUser
    vote = @_vote_for(window.currentUser)
    if vote
      vote.get('type')
    else
      'no_vote'

  _vote_for: (user) ->
    @find((vote) -> vote.get('username') == user.get('username'))

  clickCurrentUserOpinion: (type) ->
    return unless window.currentUser

    current_vote = @_vote_for(currentUser)
    if current_vote
      if current_vote.get('type') == type
        current_vote.destroy()
      else
        current_vote.set type: type
        current_vote.save()
    else
      @create
        username: currentUser.get('username')
        user: currentUser.attributes
        type: type
