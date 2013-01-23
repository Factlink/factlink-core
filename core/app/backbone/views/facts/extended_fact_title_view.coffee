class window.BackButtonView extends Backbone.Marionette.ItemView
  tagName: "a"
  className: "back-to-profile btn-back"

  template:
    text: "<span>{{ return_to_text }}</span>"

  onRender: () ->
    @$el.attr 'href', @model.get('return_to_url')
    @$el.attr 'rel', 'backbone'

class window.ExtendedFactTitleView extends Backbone.Marionette.Layout
  tagName: "div"
  template: "facts/extended_fact_title"

  regions:
    backButtonRegion : ".btn-back-region"
    creatorProfileRegion: ".created_by_region"

  initialize: ( opts ) ->
    @opts = opts

  onRender: ->
    back_button_model = new Backbone.Model(
                              return_to_text: @opts.return_to_text,
                              return_to_url: @opts.return_to_url)

    @backButtonRegion.show new BackButtonView( model: back_button_model  )
    @creatorProfileRegion.show new UserWithAuthorityBox
      model: new User(@model.get('created_by'))
      authority: @model.get('created_by').authority_for_subject.authority
