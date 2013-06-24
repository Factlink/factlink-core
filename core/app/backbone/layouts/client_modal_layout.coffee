class window.ClientModalLayout extends Backbone.Marionette.Layout
  template: 'layouts/client_modal'

  regions:
    mainRegion:          '.factlink-modal-content'
    topRegion:           '.js-region-factlink-modal-top'
    bottomRegion:        '.js-region-factlink-modal-bottom'
