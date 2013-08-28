class window.IEWarningModalWindowView extends Backbone.Marionette.ItemView
  className: 'ie-warning-modal modal-window'

  template: 'modal_windows/ie_warning_modal_window'

  events:
    'click .js-close': -> FactlinkApp.ModalWindowContainer.close()
