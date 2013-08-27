class window.FrontpageVideoModalWindowView extends Backbone.Marionette.ItemView
  className: 'modal-window frontpage-video-modal-window'

  template:
    text: """
      <div class="modal-window-body">
        <iframe src="https://player.vimeo.com/video/39821677?autoplay=1" width="740" height="416" style="border: 0px;"></iframe>
      </div>
    """
