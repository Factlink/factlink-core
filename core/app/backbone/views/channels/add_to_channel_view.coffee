#= require ./filtered_suggested_topics_view

class window.AddToChannelView extends Backbone.Marionette.Layout
  className: 'add-to-channel'
  template: 'channels/add_to_channel'

  regions:
    addToChannelRegion: ".add-to-channel-form"
    suggestedChannelsRegion: ".add-to-channel-suggested-topics-region"

  initialize: ->
    @collection = @model.getOwnContainingChannels(this)
    @collection.on "add", (channel) =>
      @model.addToChannel channel

    @collection.on "remove", (channel) =>
      @model.removeFromChannel channel

  onRender: ->
    mp_track "Factlink: Open repost modal"

    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView
      @listenTo @addToChannelView, 'error', ->
        FactlinkApp.NotificationCenter.error "The new #{Factlink.Global.t.topic} could not be created, please try again."

      @renderSuggestedChannels()

  renderSuggestedChannels: ->
    suggested_topics = new SuggestedSiteTopics([], site_url: @model.get('fact_url'))
    suggested_topics.fetch()

    suggestions = new FilteredSuggestedTopicsView
                        collection: suggested_topics
                        addToCollection: @collection

    @suggestedChannelsRegion.show suggestions

