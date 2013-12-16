class window.ClientController
  constructor: (@annotatedSiteEnvoy) ->
  showFact: (fact_id) ->
    fact = new Fact id: fact_id

    fact.on 'destroy', => @annotatedSiteEnvoy 'closeModal_deleteFactlink', fact_id

    fact.fetch
      success: =>
        newClientModal = new DiscussionModalContainer
        FactlinkApp.discussionModalRegion.show newClientModal
        view = new DiscussionView model: fact
        view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'
        newClientModal.mainRegion.show view

  showNewFact: (params={}) =>
    fact = new Fact
      displaystring: params.fact
      url: params.url
      fact_title: params.title

    if Factlink.Global.signed_in
      fact.save {},
        success: =>
          @annotatedSiteEnvoy 'highlightNewFactlink', params.fact, fact.id
          Backbone.history.navigate "/client/facts/#{fact.id}", trigger: true
    else
      view = new NewFactLoginView model: fact
      view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'

      clientModal = new DiscussionModalContainer
      FactlinkApp.discussionModalRegion.show clientModal
      clientModal.mainRegion.show view
