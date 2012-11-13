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
    window.dv = new DiscussionView(model: fact)
    @main.contentRegion.show(dv)

    window.extended_fact_title_view = new ExtendedFactTitleView( model: fact )
    @main.titleRegion.show( extended_fact_title_view )

    @showChannelListing(fact.get('created_by').username)

  showChannelListing: (username)->
    changed = window.Channels.setUsernameAndRefresh(username)
    channelCollectionView = new ChannelsView(collection: window.Channels)
    app.leftMiddleRegion.show(channelCollectionView)
    channelCollectionView.setActive('profile')
