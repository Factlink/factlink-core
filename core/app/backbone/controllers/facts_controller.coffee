app = FactlinkApp

class window.FactsController
  showFact: (slug, fact_id)->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    @main.showTitle "Fact #{fact_id}"
    fact = new Fact(id: fact_id)
    fact.fetch
      success: (model, response) => @withFact(model)

  withFact: (fact)->
    @main.setTitle "#{fact.get('displaystring')}"
    window.efv = new ExtendedFactView(model: fact)
    @main.contentRegion.show(efv)
    window.main = @main
