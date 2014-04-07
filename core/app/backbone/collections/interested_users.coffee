class window.InterestedUsers extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @fact = options.fact

  url: ->
    "/facts/#{@fact.id}/opinionators"

  is_current_user_interested: ->
    !!user_interest_state(currentSession.user().get('username'))

  user_interest_state: (username) ->
    @find (vote) -> vote.get('username') == username

  setInterested: (is_interested) ->
    return unless currentSession.signedIn()
    #TODO: why this guard - this shouldn't be possible, right?

    @fact.saveUnlessNew =>
      current_state = user_interest_state(currentSession.user().get('username'))

      if !is_interested && current_state
        current_state.destroy()
      else if is_interested && !current_state
        @create
          username: currentSession.user().get('username')
          user: currentSession.user().attributes
          type: 'believes'

  fetchIfUnloaded: ->
    return if @fact.isNew() # TODO: Save a fact in the backend when submitting a comment

    super
