class window.ClientController

  show: (fact_id) =>
    fact = new Fact id: fact_id
    fact.fetch success: =>
      fact.set 'modal?', true
      view = new DiscussionView model: fact
      @showView view

    parent.$(parent.document).trigger "modalready"

    if FactlinkApp.just_added
      parent.$(parent.document).trigger("factlinkCreated", fact_id )

  newFact: (params) => #(layout, fact_text, title, url, site_id) =>
    csrf_token = $('meta[name=csrf-token]').attr('content')
    factsNewView = new FactsNewView
      layout: params['layout']
      fact_text: params['fact']
      title: params['title']
      url: params['url']
      csrf_token: params['csrf_token']
      guided: FactlinkApp.guided
    @showView factsNewView

  # Helpers

  showView: (view) ->
    view.render()
    $('div.factlink-modal').append view.el
