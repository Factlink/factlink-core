class window.ClientController

  showFact: (fact_id) =>
    fact = new Fact id: fact_id
    fact.on 'destroy', => @onFactRemoved fact.id

    fact.fetch success: =>
      newClientModal = new ClientModalLayout
      FactlinkApp.discussionModalRegion.show newClientModal

      view = new NDPDiscussionView model: fact
      view.on 'render', =>
        parent.$(parent.document).trigger 'modalready'

      newClientModal.mainRegion.show view


  showNewFact: (params={}) =>
    unless window.currentUser?
      window.location = Factlink.Global.path.sign_in_client()
      return

    clientModal = new ClientModalLayout
    FactlinkApp.discussionModalRegion.show clientModal

    csrf_token = $('meta[name=csrf-token]').attr('content')

    FactlinkApp.guided = params.guided == 'true'

    mp_track("Modal: Open prepare") if params.fact

    factsNewView = new FactsNewView
      layout: 'client'
      fact_text: params['fact']
      title: params['title']
      url: params['url']
      csrf_token: params['csrf_token']
      guided: FactlinkApp.guided
    factsNewView.on 'render', =>
      parent.$(parent.document).trigger "modalready"

    factsNewView.on 'factCreated', (fact) =>
      parent.$(parent.document).trigger("factlinkCreated", [ fact.id, params['fact'] ] )

    clientModal.mainRegion.show factsNewView

  onFactRemoved: (id)->
    parent.remote.hide()
    parent.remote.stopHighlightingFactlink id

