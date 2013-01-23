class window.ClientController

  show: (fact_id) =>
    fact = new Fact id: fact_id
    fact.fetch success: => @showFact fact

  newFact: (params={}) => #(layout, fact_text, title, url, site_id) =>
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
      Backbone.history.navigate "facts/#{fact.id}", false
      @showFact fact

    FactlinkApp.mainRegion.show factsNewView

  onFactRemoved: ->
    parent.remote.hide()
    parent.remote.stopHighlightingFactlink @model.id

  showFact: (fact)->
    view = new DiscussionView model: fact
    view.on 'render', =>
      parent.$(parent.document).trigger "modalready"
    FactlinkApp.mainRegion.show view

    fact.on "destroy", @onFactRemoved, @
