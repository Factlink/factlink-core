class window.TopicView extends Backbone.Marionette.Layout
  template: 'topics/topic'

  regions:
    factList: '.js-region-fact-list'
    favouriteTopicRegion: '.js-region-favourite-topic'

  onRender: ->
    @showChosenFacts()
    @showFavouriteTopicButton()

  showChosenFacts: ->
    @showFacts @topicFacts()
    mp_track "Topic: World view"

  showFacts: (facts) ->
    @factList.show new FactsView collection: facts

  showFavouriteTopicButton: ->
    return unless Factlink.Global.signed_in

    view = new FavouriteTopicButtonView(topic: @model, mini: true)
    @favouriteTopicRegion.show view

  topicFacts: -> @model.facts()
