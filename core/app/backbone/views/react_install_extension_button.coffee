window.ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'

  render: ->
    _div [],
      _div ['visible-when-chrome'],
        _a ['button-success', href: 'javascript:chrome.webstore.install()'],
          'Install Factlink for Chrome'
      _div ['visible-when-firefox'],
        _a ['button-success', href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'],
          'Install Factlink for Firefox'
      _div ['visible-when-safari'],
        _a ['button-success', href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'],
          'Install Factlink for Safari'

window.ReactHugeInstallExtensionButton = React.createClass
  displayName: 'ReactHugeInstallExtensionButton'

  render: ->
    _div [],
      _div ['visible-when-chrome'],
        _a ['button-huge button-success', href: 'javascript:chrome.webstore.install()'],
          _span ['install-chrome']
          'Install Factlink for Chrome'
      _div ['visible-when-firefox'],
        _a ['button-huge button-success', href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'],
          _span ['install-firefox']
          'Install Factlink for Firefox'
      _div ['visible-when-safari'],
        _a ['button-huge button-success', href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'],
          _span ['install-safari']
          'Install Factlink for Safari'
