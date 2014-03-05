class window.ClientController
  constructor: (@annotatedSiteEnvoy) ->
  showFact: (fact_id) ->
    @_renderDiscussion new Fact id: fact_id

  showNewFact: (params={}) =>
    fact = new Fact
      displaystring: params.displaystring
      url: params.url
      site_title: params.site_title

    fact.save {},
      success: =>
        @annotatedSiteEnvoy 'highlightNewFactlink', params.displaystring, fact.id

        @_renderDiscussion fact
        Backbone.history.navigate "/client/facts/#{fact.id}", trigger: false
        mp_track 'Factlink: Created'

        if params.current_user_opinion && params.current_user_opinion != 'no_vote'
          fact.getOpinionators().trigger 'trySettingOpinion', params.current_user_opinion

  _renderDiscussion: (fact) ->
    @annotatedSiteEnvoy 'highlightExistingFactlink', fact.id
    fact.fetch()

    FactlinkApp.discussionSidebarContainer.slideIn new ReactView
      component: ReactDiscussion
        model: fact
        initiallyFocusAddComment: true
