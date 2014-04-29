class window.Comments extends Backbone.Factlink.Collection
  model: Comment

  initialize: (models, options) ->
    @fact = options.fact
    @_retrieved_username = {undefined_state:"unknown"}

  url: -> "/facts/#{@fact.id}/comments"

  # This logic is to ensure a list of comments gets reloaded
  # when the user changes. For now this supports only changin
  # from non-logged in to logged in
  #
  # to ensure this also works when the currentuser is not yet fetched,
  # we allow username to be nil, even if we actually retrieve the
  # comments for a user. We just assume the backend knows better than the
  # frontend
  #
  # Limitations:
  #
  # * this does not support logging out yet
  # * potentially there could be raceconditions if login happens during fetching,
  #   but currently we don't see harmful raceconditions (worst case it refetches)
  fetchIfUnloadedFor: (username) ->
    return if @fact.isNew() # TODO: Save a fact in the backend when submitting a comment

    @_expected_username = username

    return if @_loading

    if @_retrieved_username != @_expected_username
      @fetch(remove: false)

  parse: (response) ->
    @_retrieved_username = response.username
    if @_expected_username && @_retrieved_username != @_expected_username
      @fetch(remove: false)

    response.comments
