class window.TopicView extends Backbone.Marionette.Layout
  template: 'topics/topic'

  regions:
    factList: '.js-region-fact-list'
    subChannelsRegion: '.js-region-sub-channels'
    favouriteTopicRegion: '.js-region-favourite-topic'
    creatorProfileRegion: ".js-region-creator-profile"

  events:
    'change .js-channel-topic-switch': 'showChosenFacts'

  templateHelpers: =>
    has_channel: @channel()

  onRender: ->
    @showChosenFacts()
    @showFavouriteTopicButton()

    if @channel() and @channel().get('inspectable?')
      @subChannelsRegion.show new SubchannelsView
        collection: @channel().subchannels()
        model: @channel()

  showChosenFacts: ->
    choice = @$('.js-channel-topic-switch').val()
    if choice == 'channel'
      @showFacts @channelFacts()
      @$('.js-region-sub-channels').show()
      mp_track "Topic: People I follow"
    else
      @showFacts @topicFacts()
      @$('.js-region-sub-channels').hide()
      mp_track "Topic: World view"

  showFacts: (facts) ->
    @factList.show new FactsView collection: facts

  showFavouriteTopicButton: ->
    view = new FavouriteTopicButtonView(model: @model)
    @favouriteTopicRegion.show view

  channel: ->
    @_channel ?= @model.existingChannelFor(currentUser) || false

  channelFacts: -> new ChannelFacts [], channel: @channel()
  topicFacts: -> @model.facts()
