class window.NewFactLoginView extends Backbone.Marionette.Layout
  template: "client/new_fact_login"

  regions:
    opinionHelpRegion: '.js-opinion-help-region'

  onRender: ->
    @opinionHelpRegion.show new OpinionHelpView
