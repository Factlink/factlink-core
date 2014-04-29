class window.InterestedUsers extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @fact = options.fact

  url: ->
    "/facts/#{@fact.id}/opinionators"

  is_current_user_interested: -> !!@_current_user_interest_state()

  _current_user_interest_state: ->
    username = currentSession.user().get('username')
    @find (vote) -> vote.get('username') == username

  setInterested: (is_interested) ->
    return unless currentSession.signedIn()
    #TODO: why this guard - this shouldn't be possible, right?

    @fact.saveUnlessNew =>
      current_state = @_current_user_interest_state()

      if !is_interested && current_state
        current_state.destroy()
      else if is_interested && !current_state
        @create
          username: currentSession.user().get('username')
          user: currentSession.user().attributes

  fetchIfUnloaded: ->
    if !@fact.isNew()
      super
      # TODO: Save a fact in the backend when submitting a comment
