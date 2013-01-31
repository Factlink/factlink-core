class window.ChannelView extends Backbone.Marionette.Layout
  template: 'channels/channel'

  regions:
    factList: '.js-region-fact-list'
    subChannelsRegion: '.js-region-sub-channels'
    addToChannelRegion: '.js-region-add-to-channel'
    creatorProfileRegion: ".js-region-creator-profile"

  events:
    'click .js-channel': 'showChannelFacts'
    'click .js-topic': 'showTopicFacts'

  onRender: ->
    @showChannelFacts()

    if @model.get('inspectable?')
      @subChannelsRegion.show new SubchannelsView
        collection: @model.subchannels()
        model: @model

    if @model.get('followable?')
      @addToChannelRegion.show new AddChannelToChannelsButtonView(model: @model)

    @creatorProfileRegion.show new UserWithAuthorityBox
      model: @model.user(),
      authority: @model.get('created_by_authority')

  showChannelFacts: -> @showFacts @channelFacts()
  showTopicFacts: -> @showFacts @topicFacts()

  showFacts: (facts) ->
    @factList.show new FactsView
      model: @model
      collection: facts

  channelFacts: -> new ChannelFacts([], channel: @model)
  topicFacts: -> @model.topic().facts()
