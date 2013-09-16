class window.EvidenceishHeadingView extends Backbone.Marionette.ItemView
  className: 'discussion-evidenceish-heading'
  template: 'evidence/evidenceish_heading'

  onRender: ->
    Backbone.Factlink.makeTooltipForView @,
      positioning: {align: 'left', side: 'bottom'}
      selector: '.js-user-link'
      tooltipViewFactory: => new UserPopoverContentView model: @model
