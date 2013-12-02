window.ClientController =
  showFact: (fact_id) ->
    fact = new Fact id: fact_id

    fact.on 'destroy', ->
      parent.remote.hide()
      parent.remote.stopHighlightingFactlink fact_id

    fact.fetch success: ->
      newClientModal = new DiscussionModalContainer
      FactlinkApp.discussionModalRegion.show newClientModal
      view = new DiscussionView model: fact
      view.on 'render', -> parent.remote?.onModalReady()
      newClientModal.mainRegion.show view

  showNewFact: (params={}) ->
    clientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show clientModal
    FactlinkApp.guided = params.guided == 'true'
    if params.fact
      mp_track("Modal: Open prepare")
    factsNewView = new FactsNewView
      fact_text: params.fact
      title: params.title
      url: params.url
    factsNewView.on 'render', -> parent.remote?.onModalReady()
    factsNewView.on 'factCreated', (fact) ->
      parent.highlightLastCreatedFactlink(fact.id, params.fact)
    clientModal.mainRegion.show factsNewView

