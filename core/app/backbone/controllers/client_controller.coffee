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
      view.on 'render', ->
        parent.$(parent.document).trigger 'modalready'

      newClientModal.mainRegion.show view


  showNewFact: (params={}) ->
    unless window.currentUser?
      window.location = Factlink.Global.path.sign_in_client()
      return

    clientModal = new DiscussionModalContainer
    FactlinkApp.discussionModalRegion.show clientModal

    csrf_token = $('meta[name=csrf-token]').attr('content')

    FactlinkApp.guided = params.guided == 'true'

    if params.fact
      mp_track("Modal: Open prepare")

    factsNewView = new FactsNewView
      layout: 'client'
      fact_text: params['fact']
      title: params['title']
      url: params['url']
      csrf_token: params['csrf_token']
      guided: FactlinkApp.guided

    factsNewView.on 'render', ->
      parent.$(parent.document).trigger "modalready"

    factsNewView.on 'factCreated', (fact) ->
      parent.triggerHighlightNewFactlink(fact.id, params['fact'])

    clientModal.mainRegion.show factsNewView

