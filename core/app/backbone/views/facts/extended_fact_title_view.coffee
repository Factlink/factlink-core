class window.ExtendedFactTitleView extends Backbone.Marionette.Layout
  template: "facts/extended_fact_title"

  regions:
    creatorProfileRegion: ".created_by_region"

  initialize: ->
    @listenTo @model, 'change', @updateUserWithAuthorityBox

  onRender: ->
    @updateUserWithAuthorityBox()

  updateUserWithAuthorityBox: ->
    return unless @model.has('created_by')

    @creatorProfileRegion.show new UserWithAuthorityBox
      model: new User(@model.get('created_by'))
      authority: @model.get('created_by').authority_for_subject.authority
