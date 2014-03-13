if FactlinkConfig.env != 'production'
  console.log FactlinkConfig.env
  content = """
    <div class="environment-message">
      This is the factlink #{FactlinkConfig.env} environment, not production!
    </div>
  """

  frame = new FactlinkJailRoot.ControlIframe content

  frame.$el.addClass 'factlink-control-frame-environment-message'

  frame.$frameBody.on 'click', =>
    frame.fadeOut().then(->frame.destroy())

  frame.fadeIn()
