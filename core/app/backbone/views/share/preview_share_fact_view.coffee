class window.PreviewShareFactView extends Backbone.Marionette.Layout
  className: 'preview-share-fact'

  template: 'share/preview_share_fact'

  regions:
    shareButtonsRegion: '.js-share-buttons-region'

  events:
    'click .js-share': '_share'

  templateHelpers: =>
    provider_name: @_niceProviderName()

  _share: ->
    @model.share @options.provider_name,
      success: =>
        FactlinkApp.NotificationCenter.success "Sharing to #{@_niceProviderName()} in a minute!"
        @trigger 'success'
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing to #{@_niceProviderName()}"

  _niceProviderName: -> @options.provider_name.capitalize()
