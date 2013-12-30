class window.PreviewShareFactView extends Backbone.Marionette.ItemView
  className: 'preview-share-fact'

  template: 'share/preview_share_fact'

  events:
    'click .js-share': '_share'

  templateHelpers: =>
    provider_name: @options.provider_name
    nice_provider_name: @_niceProviderName()
    connected: currentUser.serviceConnected(@options.provider_name)
    connectButtonClass: @_connectButtonClass()

  initialize: ->
    @listenTo currentUser, 'change:services', @render

  _share: ->
    provider_names = {}
    provider_names[@options.provider_name] = true

    @model.share provider_names, null,
      success: =>
        FactlinkApp.NotificationCenter.success "Sharing to #{@_niceProviderName()}."
        @trigger 'success'
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing to #{@_niceProviderName()}"

  _niceProviderName: -> @options.provider_name.capitalize()

  _connectButtonClass: ->
    switch @options.provider_name
      when 'twitter' then 'button-twitter'
      when 'facebook' then 'button-facebook'
