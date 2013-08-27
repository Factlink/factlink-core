class window.IEWarningModalWindowView extends Backbone.Marionette.ItemView
  className: 'ie-warning-modal modal-window'

  template:
    text: """
      <div class="modal-window-body warning-sign">
        <img class="warning-sign" src="{{global.warning_sign_image}}">
        <h2>Your browser is not supported</h2>
        <p>Factlink is not working with your browser. To use Factlink, we recommend using the latest version of Google Chrome.</p>
      </div>
      <div class="modal-window-footer">
        <a href="#" class="proceed js-close">Proceed anyway</a>
        <a id="chrome-download-button" class="button download-chrome" href="https://google.com/chrome" target="_blank">
          <img src="{{global.browser_icons_chrome_16x16}}" style="margin: -4px 8px 0 0">
           Install Google Chrome
        </a>
      </div>
    """

  events:
    'click .js-close': -> FactlinkApp.ModalWindowContainer.close()
