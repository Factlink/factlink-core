class window.BackButtonView extends Backbone.Marionette.ItemView
  tagName: "a"
  className: "back-to-profile btn-back"

  template:
    text: "<span>{{ text }}</span>"

  initialize: ->
    @bindTo @model, 'change', @render

  onRender: () ->
    @$el.attr 'href', @model.get('url')
    @$el.attr 'rel', 'backbone'

class window.ExtendedFactTitleView extends Backbone.Marionette.Layout
  template: "facts/extended_fact_title"

  regions:
    backButtonRegion : ".btn-back-region"
    creatorProfileRegion: ".created_by_region"

  initialize: ( opts ) ->
    @opts = opts

  onRender: ->
    @backButtonRegion.show new BackButtonView( model: @options.back_button  )
    @creatorProfileRegion.show new UserWithAuthorityBox
      model: new User(@model.get('created_by'))
      authority: @model.get('created_by').authority_for_subject.authority

  onClose: ->
    @options.back_button.stopListening()
