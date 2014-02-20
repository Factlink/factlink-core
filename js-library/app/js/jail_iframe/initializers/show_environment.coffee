if FactlinkEnvironment != 'production'
  console.log FactlinkEnvironment
  content = """
    <div class="environment-message">
      This is the factlink #{FactlinkEnvironment} environment, not production!
    </div>
  """

  frame = new FactlinkJailRoot.ControlIframe content

  frame.$el.addClass 'factlink-control-frame-environment-message'

  frame.$frameBody.on 'click', =>
    frame.fadeOut().then(->frame.destroy())

  frame.fadeIn()
