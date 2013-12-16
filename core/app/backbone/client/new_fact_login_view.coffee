class window.NewFactLoginView extends Backbone.Marionette.Layout
  template: "client/new_fact_login"

  regions:
    learnMoreRegion: '.js-learn-more-region'

  onRender: ->
    @learnMoreRegion.show new LearnMoreView
