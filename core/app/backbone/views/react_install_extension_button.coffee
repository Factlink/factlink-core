determineBrowser = ->
  [ 'chrome', 'firefox', 'safari', 'phantom_js', 'unsupported-browser' ]
  .filter( (browser) -> $('html.'+browser).length
  )[0]
window.ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'
  render: ->
    browserName = determineBrowser()
    extra_class = if @props.huge_button then 'button-huge' else null
    if document.documentElement.getAttribute('data-factlink-extension-loaded') != undefined
      _div [],
        _button ['button', extra_class,
          disabled: true],
          'Factlink already installed.'
    else
      _div [],
        _div ['visible-when-chrome'],
          _a ['button-success', extra_class, href: 'javascript:chrome.webstore.install()'],
            _span ['install-chrome']
            'Install Factlink for ' + browserName.capitalize()
        _div ['visible-when-firefox'],
          _a ['button-success', extra_class, href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'],
            _span ['install-firefox']
            'Install Factlink for ' + browserName.capitalize()
        _div ['visible-when-safari'],
          _a ['button-success', extra_class, href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'],
            _span ['install-safari']
            'Install Factlink for ' + browserName.capitalize()

