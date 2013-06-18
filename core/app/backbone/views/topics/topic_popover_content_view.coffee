class window.TopicPopoverContentView extends Backbone.Marionette.Layout
  template:
    text: """
      <strong>{{title}}</strong>
      <div class="js-favourite-button-region"></div>
    """

  regions:
    favouriteButtonRegion: '.js-favourite-button-region'

  onRender: ->
    @favouriteButtonRegion.show new FavouriteTopicButtonView(topic: @model, mini: true)
