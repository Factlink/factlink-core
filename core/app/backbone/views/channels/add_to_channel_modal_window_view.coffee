#= require ./filtered_suggested_topics_view

class window.AddToChannelModalWindowView extends Backbone.Marionette.Layout

  className: 'modal-window'

  template: 'channels/add_to_channel_modal_window'

  regions:
    addToChannelRegion: ".add-to-channel-form"
    suggestedChannelsRegion: ".add-to-channel-suggested-topics-region"

  events:
    'click .js-close': -> FactlinkApp.ModalWindowContainer.close()

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

