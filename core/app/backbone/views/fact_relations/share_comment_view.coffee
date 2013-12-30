class window.ShareCommentView extends Backbone.Marionette.Layout
  className: 'share-comment'
  template: 'comments/share_comment'

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
    @_submitting = true
    @render()

    @model.share provider_names, message,
      complete: => @_submitting = false; @render()
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing"

  _selectedProviderNames: ->
    twitter: @ui.twitterCheckbox.prop('checked') || false
    facebook: @ui.facebookCheckbox.prop('checked') || false
