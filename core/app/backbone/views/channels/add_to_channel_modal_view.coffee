#= require ./filtered_suggested_topics_view

class window.AddToChannelModalView extends Backbone.Marionette.Layout
  template: 'channels/add_to_channel_modal'

  regions:
    addToChannelRegion: ".add-to-channel-form"
    suggestedChannelsRegion: ".add-to-channel-suggested-topics-region"

  initialEvents: -> false # stop layout from refreshing after model/collection update
                  # no longer needed in marionette 1.0

  initialize: ->
    @alertErrorInit ['create_channel']

  onRender: ->
    unless @addToChannelView?
      @addToChannelView = new AutoCompleteChannelsView collection: @collection
      @addToChannelRegion.show @addToChannelView
      @alertBindErrorEvent @addToChannelView

      @renderSuggestedChannels()

  renderSuggestedChannels: ->
    suggestions = new FilteredSuggestedTopicsView
                        site_url: @model.get('fact_url')
                        addToCollection: @collection

    @suggestedChannelsRegion.show suggestions

_.extend(AddToChannelModalView.prototype, Backbone.Factlink.AlertMixin)
