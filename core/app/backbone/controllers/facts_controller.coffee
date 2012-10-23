app = FactlinkApp

class window.FactsController
  showFact: (slug, fact_id)->
    app.closeAllContentRegions()
    @main = new TabbedMainRegionLayout();
    app.mainRegion.show(@main)

    fact = new Fact(id: fact_id)
    fact.fetch
      success: (model, response) => @withFact(model)

  withFact: (fact)->
    window.efv = new ExtendedFactView(model: fact)
    @main.contentRegion.show(efv)

    window.extended_fact_title_view = new ExtendedFactTitleView( model: fact )
    @main.titleRegion.show( extended_fact_title_view )
