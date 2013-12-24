class window.PreviewShareFactView extends Backbone.Marionette.ItemView
  className: 'preview-share-fact'

  template: 'share/preview_share_fact'

  events:
    'click .js-share': '_share'

  templateHelpers: =>
    provider_name: @options.provider_name
    nice_provider_name: @_niceProviderName()
    connected: currentUser.serviceConnected(@options.provider_name)

  _share: ->
    @model.share @options.provider_name,
      success: =>
        FactlinkApp.NotificationCenter.success "Sharing to #{@_niceProviderName()}."
        @trigger 'success'
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing to #{@_niceProviderName()}"

  _niceProviderName: -> @options.provider_name.capitalize()
