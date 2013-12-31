class window.ClientController
  constructor: (@annotatedSiteEnvoy) ->
  showFact: (fact_id) ->
    @_renderDiscussion new Fact id: fact_id

  showNewFact: (params={}) =>
    fact = new Fact
      displaystring: params.displaystring
      url: params.url
      fact_title: params.fact_title

    if Factlink.Global.signed_in
      fact.save {},
        success: =>
          if params.current_user_opinion
            fact.getFactTally().clickCurrentUserOpinion params.current_user_opinion

          @annotatedSiteEnvoy 'highlightNewFactlink', params.displaystring, fact.id
          FactlinkApp.NotificationCenter.success "Created #{Factlink.Global.t.factlink}."

          @_renderDiscussion fact
          Backbone.history.navigate "/client/facts/#{fact.id}", trigger: false
    else
      view = new NewFactLoginView model: fact
      view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'

      clientModal = new DiscussionModalContainer
      FactlinkApp.discussionModalRegion.show clientModal
      clientModal.mainRegion.show view

  _renderDiscussion: (fact) ->
    fact.on 'destroy', => @annotatedSiteEnvoy 'deleteFactlink', fact.id

    fact.fetch
      success: =>
        newClientModal = new DiscussionModalContainer
        FactlinkApp.discussionModalRegion.show newClientModal
        view = new DiscussionView model: fact
        view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'
        newClientModal.mainRegion.show view
