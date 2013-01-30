class window.AddChannelToChannelsModalView extends Backbone.Marionette.Layout
  template: 'channels/add_channel_to_channels_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"
    suggestedTopicsRegion: '.js-add-channel-to-channels-suggested-topics-region'

  initialEvents: -> false # stop layout from refreshing after model/collection update
                  # no longer needed in marionette 1.0

  initialize: ->
    @alertErrorInit ['create_channel', 'add_channel', 'remove_channel']

    @bindTo @collection, "add", (channel) =>
      @alertHide()
      channel.addToChannel @model,
        error: =>
          @alertError 'add_channel'
          @collection.remove channel, silent: true

    @bindTo @collection, "remove", (channel) =>
      @alertHide()
      channel.removeFromChannel @model,
        error: =>
          @alertError 'remove_channel'
          @collection.add channel, silent: true

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView

      @alertBindErrorEvent @addToChannelView

    suggestions = new FilteredSuggestedTopicsView
                            suggested_topics: @options.suggestions
                            addToCollection: @collection

    @suggestedTopicsRegion.show suggestions

_.extend(AddChannelToChannelsModalView.prototype, Backbone.Factlink.AlertMixin)
