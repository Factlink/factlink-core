class window.ShareFactSelectionView extends Backbone.Marionette.Layout
  className: 'share-fact-selection'
  template: 'comments/share_fact_selection'

  ui:
    twitterCheckbox: '.js-share-twitter input'
    facebookCheckbox: '.js-share-facebook input'

  templateHelpers: ->
    connected_twitter: currentUser.serviceConnected 'twitter'
    connected_facebook: currentUser.serviceConnected 'facebook'
    submitting: @_submitting

  initialize: ->
    @listenTo currentUser, 'change:services', @render

  onRender: ->
    @trigger 'removeTooltips'

    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'top'
        popover_className: 'translucent-popover'
      selector: '.js-connect-twitter'
      tooltipViewFactory: => new TextView text: 'Connect with Twitter'

    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'top'
        popover_className: 'translucent-popover'
      selector: '.js-connect-facebook'
      tooltipViewFactory: => new TextView text: 'Connect with Facebook'

    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'top'
        popover_className: 'translucent-popover'
      selector: '.js-share-twitter'
      tooltipViewFactory: => new TextView text: 'Share to Twitter'

    Backbone.Factlink.makeTooltipForView @,
      positioning:
        side: 'top'
        popover_className: 'translucent-popover'
      selector: '.js-share-facebook'
      tooltipViewFactory: => new TextView text: 'Share to Facebook'

  submit: (message) ->
    # TODO: storing provider names in a model, so we don't necessarily
    # have to execute in this order
    provider_names = @_selectedProviderNames()
    return if provider_names.length == 0

    @_submitting = true
    @render()

    @model.share provider_names, message,
      complete: => @_submitting = false; @render()
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing"

  _selectedProviderNames: ->
    names = []
    names.push 'twitter' if @ui.twitterCheckbox.prop('checked')
    names.push 'facebook' if @ui.facebookCheckbox.prop('checked')
    names