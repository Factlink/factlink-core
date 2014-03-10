window.ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'

  render: ->
    _div [],
      _div ['visible-when-chrome'],
        _a ['button-success', @props.extraButtonClasses, href: 'javascript:chrome.webstore.install()'],
          _span ['install-chrome']
          'Install Factlink for Chrome'
      _div ['visible-when-firefox'],
        _a ['button-success', @props.extraButtonClasses, href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'],
          _span ['install-firefox']
          'Install Factlink for Firefox'
      _div ['visible-when-safari'],
        _a ['button-success', @props.extraButtonClasses, href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'],
          _span ['install-safari']
          'Install Factlink for Safari'
