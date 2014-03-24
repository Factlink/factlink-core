class window.Opinionators extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @fact = options.fact

  url: ->
    "/facts/#{@fact.id}/opinionators"

  opinion_for_current_user:  ->
    return 'no_vote' unless FactlinkApp.signedIn()
    vote = @vote_for(window.session.user().get('username'))
    if vote
      vote.get('type')
    else
      'no_vote'

  vote_for: (username) ->
    @find (vote) -> vote.get('username') == username

  clickCurrentUserOpinion: (type) ->
    return unless FactlinkApp.signedIn()

    @fact.saveUnlessNew =>
      current_vote = @vote_for(session.user().get('username'))
      if current_vote
        if current_vote.get('type') == type
          current_vote.destroy()
        else
          current_vote.set type: type
          current_vote.save()
      else
        @create
          username: session.user().get('username')
          user: session.user().attributes
          type: type

  fetchIfUnloaded: ->
    return if @fact.isNew() # TODO: Save a fact in the backend when submitting a comment

    super
