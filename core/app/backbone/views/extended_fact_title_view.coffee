class window.ExtendedFactTitleView extends Backbone.Marionette.Layout
  tagName: "header"
  id: "single-factlink-header"

  template: "facts/_extended_fact_title"

  regions:
    creatorProfileRegion: ".created_by_info"

  onRender: ->
    @creatorProfileRegion.show new UserWithAuthorityBox(model: @model)
