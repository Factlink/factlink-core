FactlinkJailRoot.public_events.on 'proxyLoaded', ->
  content = """
    <div class="proxy-message">
      <span class="close">&times;</span>

      You're looking at this page through <a target="_blank" href="https://factlink.com/">Factlink</a> <!--Keep the space here to allow for a browser rounding error!--><br>
      (visit <a target="_blank" href="#{FactlinkJailRoot.siteUrl()}">original page</a>)
    </div>
  """

  frame = new FactlinkJailRoot.ControlIframe content

  frame.$el.addClass 'factlink-control-frame-proxy-message'

  frame.$frameBody.find('.close').on 'click', =>
    frame.fadeOut()

  frame.fadeIn()
