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

    if @model.get('inspectable?')
      @subChannelsRegion.show new SubchannelsView
        collection: @model.subchannels()
        model: @model

    if @model.get('followable?')
      @addToChannelRegion.show new FollowChannelButtonView(model: @model)

    @creatorProfileRegion.show new UserWithAuthorityBox
      model: @model.user(),
      authority: @model.get('created_by_authority')

  showChosenFacts: ->
    choice = @$('.js-channel-topic-switch').val()
    if choice == 'topic'
      @showFacts @topicFacts()
      @$('.js-region-sub-channels').hide()
      mp_track "Topic: World view"
    else
      @showFacts @channelFacts()
      @$('.js-region-sub-channels').show()
      mp_track "Topic: People I follow"

  showFacts: (facts) ->
    @factList.show new FactsView
      model: @model
      collection: facts

  channelFacts: -> new ChannelFacts([], channel: @model)
  topicFacts: -> @model.topic().facts()
