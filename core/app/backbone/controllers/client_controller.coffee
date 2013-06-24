class window.ClientController

  show: (fact_id) =>
    fact = new Fact id: fact_id
    fact.fetch success: =>
      if Factlink.Global.can_haz['new_discussion_page']
        @showNewFact fact
      else
        @showFact fact

  newFact: (params={}) =>
    unless window.currentUser?
      window.location = Factlink.Global.path.sign_in_client()
      return

    clientModal = new ClientModalLayout
    FactlinkApp.mainRegion.show clientModal

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
      parent.$(parent.document).trigger("factlinkCreated", fact.id )

    clientModal.mainRegion.show factsNewView

  onFactRemoved: (id)->
    parent.remote.hide()
    parent.remote.stopHighlightingFactlink id

  showFact: (fact)->
    clientModal = new ClientModalLayout
    FactlinkApp.mainRegion.show clientModal

    view = new DiscussionView model: fact
    view.on 'render', =>
      parent.$(parent.document).trigger "modalready"

    clientModal.mainRegion.show view

    fact.on "destroy", => @onFactRemoved(fact.id)

    unless Factlink.Global.signed_in
      clientModal.topRegion.show new LearnMorePopupView()
      clientModal.bottomRegion.show new LearnMoreBottomView()

  showNewFact: (fact) ->
    newClientModal = new ClientModalLayout2
    FactlinkApp.mainRegion.show newClientModal

    view = new NewDiscussionView model: fact
    view.on 'render', =>
      parent.$(parent.document).trigger 'modalready'

    newClientModal.mainRegion.show view

    fact.on 'destroy', => @onFactRemoved fact.id
