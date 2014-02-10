FactlinkJailRoot.public_events.on 'proxyLoaded', ->
  content = """
    <div class="proxy-message">
      <strong>Factlink Browser</strong>
      <ul>
        <li>Get the <a target="_blank" href="https://factlink.com">extension</a> to add discussions on every site</li>
        <li>Or <a target="_blank" href="https://factlink.com/p/on-your-site">install</a> Factlink on your own site</li>
        <li>Visit <a target="_blank" href="#{FactlinkJailRoot.siteUrl()}">original page</a> without Factlink</li>
      </ul>
    </div>
  """

  frame = new FactlinkJailRoot.ControlIframe content

  frame.$el.addClass 'factlink-control-frame-proxy-message'

  frame.fadeIn()
