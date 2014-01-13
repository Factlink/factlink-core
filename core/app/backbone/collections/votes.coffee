class window.Votes extends Backbone.Factlink.Collection
  model: Vote

  initialize: (models, options) ->
    @_fact_id = options.fact.id

  url: ->
    "/facts/#{@_fact_id}/opinionators"

  opinion_for: (user)->
    vote = @find((vote)-> vote.get('username') == user.get('username'))
    if vote
      vote.get('type')
    else
      'no_vote'
