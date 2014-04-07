class window.InterestedUsers extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @fact = options.fact

  url: ->
    "/facts/#{@fact.id}/opinionators"

  opinion_for_current_user:  ->
    return 'no_vote' unless currentSession.signedIn()
    vote = @vote_for(window.currentSession.user().get('username'))
    if vote
      vote.get('type')
    else
      'no_vote'

  vote_for: (username) ->
    @find (vote) -> vote.get('username') == username

  setInterested: (is_interested) ->
    return unless currentSession.signedIn()
    #TODO: why this guard - this shouldn't be possible, right?

    @fact.saveUnlessNew =>
      current_vote = @vote_for(currentSession.user().get('username'))

      if !is_interested && current_vote
        current_vote.destroy()
      else if is_interested && !current_vote
        @create
          username: currentSession.user().get('username')
          user: currentSession.user().attributes
          type: 'believes'

  fetchIfUnloaded: ->
    return if @fact.isNew() # TODO: Save a fact in the backend when submitting a comment

    super
