class window.TourAuthorityPopoverView extends Backbone.Marionette.ItemView
  template: 'tour/authority_popover'

  triggers:
    'click .js-next': 'next'
