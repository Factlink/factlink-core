#= require ./suggested_site_topics_view

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
    suggested_topics = new SuggestedSiteTopics([], { site_id: @model.get('site_id') } )
    suggested_topics.fetch()

    filtered_channels = collectionDifference(new Backbone.Collection(),
                                                  'slug_title',
                                                  suggested_topics,
                                                  @collection)

    suggestions = new SuggestedSiteTopicsView
                        collection:      filtered_channels
                        addToCollection: @collection

    @suggestedChannelsRegion.show suggestions

_.extend(AddToChannelModalView.prototype, Backbone.Factlink.AlertMixin)
