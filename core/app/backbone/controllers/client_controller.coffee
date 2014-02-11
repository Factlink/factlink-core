class window.ClientController
  constructor: (@annotatedSiteEnvoy) ->
  showFact: (fact_id) ->
    @_renderDiscussion new Fact id: fact_id

  showNewFact: (params={}) =>
    fact = new Fact
      displaystring: params.displaystring
      url: params.url
      site_title: params.site_title

    if Factlink.Global.signed_in
      fact.save {},
        success: =>
          if params.current_user_opinion && params.current_user_opinion != 'no_vote'
            fact.getVotes().clickCurrentUserOpinion params.current_user_opinion

          @annotatedSiteEnvoy 'highlightNewFactlink', params.displaystring, fact.id

          @_renderDiscussion fact
          Backbone.history.navigate "/client/facts/#{fact.id}", trigger: false
          mp_track 'Factlink: Created'
    else
      view = new NewFactLoginView model: fact
      view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'

      FactlinkApp.discussionSidebarContainer.slideIn view

  _renderDiscussion: (fact) ->
    @annotatedSiteEnvoy 'highlightExistingFactlink', fact.id

    fact.on 'destroy', => @annotatedSiteEnvoy 'deleteFactlink', fact.id

    fact.fetch
      success: =>
        view = new DiscussionView model: fact
        view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'
        FactlinkApp.discussionSidebarContainer.slideIn view
