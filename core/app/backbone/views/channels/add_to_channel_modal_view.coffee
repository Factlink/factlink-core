#= require ./suggested_channels_view

class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"
    suggestedChannelsRegion: ".add-to-channel-suggested-channels-region"

  onRender: ->
    unless @addToChannelView
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

    @renderSuggestedChannels()

  renderSuggestedChannels: ->
    suggested_channels = new SuggestedChannels()
    suggested_channels.fetch()

    filtered_channels = collectionDifference(new SuggestedChannels(),
                                                  'slug_title',
                                                  suggested_channels,
                                                  @collection)

    suggestions = new SuggestedChannelsView
                        collection: filtered_channels

    @suggestedChannelsRegion.show suggestions
