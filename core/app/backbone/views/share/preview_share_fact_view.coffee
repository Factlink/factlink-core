class window.PreviewShareFactView extends Backbone.Marionette.Layout
  className: 'preview-share-fact'

  template: 'share/preview_share_fact'

  regions:
    shareButtonsRegion: '.js-share-buttons-region'

  events:
    'click .js-share': '_share'

  templateHelpers: =>
    provider_name: @options.provider_name.capitalize()

  _share: ->
    @model.share @options.provider_name, => @trigger 'success'
