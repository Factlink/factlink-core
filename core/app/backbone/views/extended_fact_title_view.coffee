class window.ExtendedFactTitleView extends Backbone.Marionette.Layout
  tagName: "header"
  id: "single-factlink-header"

  template: "facts/extended_fact_title"

  events:
    "click .back-to-profile": "navigateToProfile"

  regions:
    creatorProfileRegion: ".created_by_region"

  onRender: ->
    @creatorProfileRegion.show new UserWithAuthorityBox(model: @model)

  navigateToProfile: (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
    Backbone.history.navigate @model.get('created_by').url, true
