class window.ClientController
  constructor: (@annotatedSiteEnvoy) ->
  showFact: (fact_id) ->
    @_renderDiscussion new Fact id: fact_id

  showNewFact: (params={}) =>
    fact = new Fact
      displaystring: params.displaystring
      url: params.url
      site_title: params.site_title

    if FactlinkApp.signedIn()
      fact.save {},
        success: =>
          if params.current_user_opinion && params.current_user_opinion != 'no_vote'
            fact.getOpinionators().clickCurrentUserOpinion params.current_user_opinion

          @annotatedSiteEnvoy 'highlightNewFactlink', params.displaystring, fact.id

          @_renderDiscussion fact
          Backbone.history.navigate "/client/facts/#{fact.id}", trigger: false
          mp_track 'Factlink: Created'
    else
      # if we're not logged in because we are still loading, log in
      # normally this shouldn't happen often, because blank already loads
      # the user, but it's still good to allow this case, and the acceptance
      # tests also need it
      onChange = =>
        currentUser.off 'change', onChange
        @showNewFact(params)
      currentUser.on 'change', onChange

      view = new NewFactLoginView model: fact
      view.on 'render', => @annotatedSiteEnvoy 'openModalOverlay'

      FactlinkApp.discussionSidebarContainer.slideIn view

  _renderDiscussion: (fact) ->
    @annotatedSiteEnvoy 'highlightExistingFactlink', fact.id

    FactlinkApp.discussionSidebarContainer.slideIn new ReactView
      component: ReactDiscussion
        model: fact
        initiallyFocusAddComment: true

    @annotatedSiteEnvoy 'openModalOverlay'

    fact.fetch()
