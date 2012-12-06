#= require ./suggested_channels_view

class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"
    suggestedChannelsRegion: ".add-to-channel-suggested-channels-region"

  initialize: ->
    @alertErrorInit ['create_channel']

  templateHelpers: =>
    can_haz_channel_suggestions: window.Factlink.Global.can_haz.channel_suggestions

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView
      @alertBindErrorEvent @addToChannelView

      @renderSuggestedChannels() if window.Factlink.Global.can_haz.channel_suggestions

  renderSuggestedChannels: ->
    suggested_channels = new SuggestedChannels()
    suggested_channels.fetch()

    filtered_channels = collectionDifference(new SuggestedChannels(),
                                                  'slug_title',
                                                  suggested_channels,
                                                  @collection)

    suggestions = new SuggestedChannelsView
                        collection:      filtered_channels
                        addToCollection: @collection

    @suggestedChannelsRegion.show suggestions

_.extend(AddToChannelModalView.prototype, Backbone.Factlink.AlertMixin)
