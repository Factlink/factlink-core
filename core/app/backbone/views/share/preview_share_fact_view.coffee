class window.PreviewShareFactView extends Backbone.Marionette.Layout
  className: 'preview-share-fact'

  template: 'share/preview_share_fact'

  regions:
    shareButtonsRegion: '.js-share-buttons-region'

  templateHelpers: =>
    provider_name: @options.provider_name.capitalize()
