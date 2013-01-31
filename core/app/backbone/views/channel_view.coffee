class window.ChannelView extends Backbone.Marionette.Layout
  template: 'channels/channel'

  regions:
    factList: '#facts_for_channel'
    subChannelsRegion: '.js-subchannels-region'
    addToChannelRegion: '.add-to-channel-region'
    creatorProfileRegion: ".created_by_region"

  initialize: (opts) ->
    @on 'render', =>
      @renderSubChannels()
      if @model.get('followable?')
        @addToChannelRegion.show new AddChannelToChannelsButtonView(model: @model)
      @creatorProfileRegion.show new UserWithAuthorityBox
        model: @model.user(),
        authority: @model.get('created_by_authority')

  renderSubChannels: ->
    if @model.get('inspectable?')
      @subChannelsRegion.show new SubchannelsView
        collection: @model.subchannels()
        model: @model

  onRender: ->
    @showChannelFacts()


  showChannelFacts: -> @showFacts @channelFacts()
  showTopicFacts: -> @showFacts @topicFacts()

  showFacts: (facts) ->
    @factList.show new FactsView
      model: @model
      collection: facts

  channelFacts: -> new ChannelFacts([], channel: @model)

  topicFacts: -> @model.topic().facts()
