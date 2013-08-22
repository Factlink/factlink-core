class window.ClientController

  showFact: (fact_id) =>
    fact = new Fact id: fact_id
    fact.fetch success: =>
      if Factlink.Global.can_haz['new_discussion_page']
        @showFactWithNewDiscussionPage fact
      else
        @showFactWithOldDiscussionPage fact

  showNewFact: (params={}) =>
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
      parent.$(parent.document).trigger("factlinkCreated", [ fact.id, params['fact'] ] )

    clientModal.mainRegion.show factsNewView

  onFactRemoved: (id)->
    parent.remote.hide()
    parent.remote.stopHighlightingFactlink id

  showFactWithOldDiscussionPage: (fact)->
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

  showFactWithNewDiscussionPage: (fact) ->
    newClientModal = new NDPClientModalLayout
    FactlinkApp.mainRegion.show newClientModal

    view = new NDPDiscussionView model: fact
    view.on 'render', =>
      parent.$(parent.document).trigger 'modalready'

    newClientModal.mainRegion.show view

    fact.on 'destroy', => @onFactRemoved fact.id
