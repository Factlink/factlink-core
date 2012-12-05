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
    # TODO 0412
    # Only suggest channelx that can be added, something like:
    # collectionDifference suggested_channels, channels_that_fact_is_in
    suggestions = new SuggestedChannelsView
                        collection: suggested_channels
    @suggestedChannelsRegion.show suggestions
