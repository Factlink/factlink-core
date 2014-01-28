FactlinkJailRoot.showProxyMessage = ->
  content = """
    <div class="proxy-message">
      <strong>Factlink demo page</strong>
      <ul>
        <li>Get the <a href="https://factlink.com">extension</a> to add discussions on every site
        <li>Or <a href="https://factlink.com/p/on-your-site">install</a> Factlink on your own site
      </ul>
    </a>
  """

  frame = new FactlinkJailRoot.ControlIframe content

  frame.$el.css
    top: '10px'
    left: 'auto'
    right: '10px'
    position: 'fixed'

  frame.fadeIn()
