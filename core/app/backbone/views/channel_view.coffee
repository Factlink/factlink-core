class window.ChannelView extends Backbone.Marionette.Layout
  template: 'channels/channel'

  regions:
    factList: '.js-region-fact-list'
    subChannelsRegion: '.js-region-sub-channels'
    addToChannelRegion: '.js-region-add-to-channel'
    creatorProfileRegion: ".js-region-creator-profile"

  events:
    'change .js-channel-topic-switch': 'showChosenFacts'

  onRender: ->
    @showChosenFacts()

    @subChannelsRegion.show new SubchannelsView
      collection: @model.subchannels()
      model: @model

    if not @model.is_mine()
      @addToChannelRegion.show new FollowChannelButtonView(channel: @model, mini: true)

    @creatorProfileRegion.show new UserWithAuthorityBox
      model: @model.user(),
      authority: @model.get('created_by_authority')

  showChosenFacts: ->
    @showFacts @channelFacts()
    mp_track "Topic: User channel"

  showFacts: (facts) ->
    @factList.show new FactsView collection: facts

  channelFacts: -> new ChannelFacts([], channel: @model)
