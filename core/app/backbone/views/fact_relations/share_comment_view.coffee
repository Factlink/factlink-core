class window.ShareCommentView extends Backbone.Marionette.Layout
  className: 'share-comment'
  template: 'comments/share_comment'

  ui:
    twitterCheckbox: '.js-share-twitter input'
    facebookCheckbox: '.js-share-facebook input'

  templateHelpers: ->
    connected_twitter: currentUser.serviceConnected 'twitter'
    connected_facebook: currentUser.serviceConnected 'facebook'

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

  isSelected: (provider_name) ->
    switch provider_name
      when 'twitter' then @ui.twitterCheckbox.prop('checked') || false
      when 'facebook' then @ui.facebookCheckbox.prop('checked') || false
