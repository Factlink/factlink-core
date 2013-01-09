class window.ClientController

  show: (fact_id) =>
    fact = new Fact id: fact_id
    fact.fetch success: =>
      view = new DiscussionView model: fact
      @showView view

    parent.$(parent.document).trigger "modalready"

    if FactlinkApp.just_added
      parent.$(parent.document).trigger("factlinkCreated", fact_id )

  newFact: (layout, fact_text, title, url, site_id) =>
    csrf_token = $('meta[name=csrf-token]').attr('content')

    factsNewView = new FactsNewView
      layout: layout
      fact_text: fact_text
      title: title
      url: url
      csrf_token: csrf_token
      site_id: site_id
    @showView factsNewView

  # Helpers

  showView: (view) ->
    view.render()
    $('div.factlink-modal').append view.el
