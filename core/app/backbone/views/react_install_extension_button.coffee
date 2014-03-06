window.ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'

  render: ->
    _div [],
      _div ['visible-when-chrome'],
        _a ['button-success', @props.extraButtonClasses, href: 'javascript:chrome.webstore.install()'],
          'Install Factlink for Chrome'
      _div ['visible-when-firefox'],
        _a ['button-success', @props.extraButtonClasses, href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'],
          'Install Factlink for Firefox'
      _div ['visible-when-safari'],
        _a ['button-success', @props.extraButtonClasses, href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'],
          'Install Factlink for Safari'
