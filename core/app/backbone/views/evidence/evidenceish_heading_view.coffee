class window.EvidenceishHeadingView extends Backbone.Marionette.ItemView
  className: 'comment-heading'
  template: 'evidence/evidenceish_heading'

  onRender: ->
    UserPopoverContentView.makeTooltip @, @model
