class window.ClientController

  show: (fact_id) ->
    fact = new Fact id: fact_id
    fact.fetch success: ->
      view = new DiscussionView model: fact
      view.render()
      $('div.factlink-modal').append view.el

    parent.$(parent.document).trigger "modalready"

    if FactlinkApp.just_added
      parent.$(parent.document).trigger("factlinkCreated", fact_id )
