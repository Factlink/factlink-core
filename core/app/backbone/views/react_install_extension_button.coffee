determineBrowser = ->
  [ 'chrome', 'firefox', 'safari', 'phantom_js', 'unsupported-browser' ]
  .filter( (browser) -> $('html.'+browser).length
  )[0]

extension_link_by_browser =
  firefox: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'
  safari: 'https://static.factlink.com/extension/firefox/factlink.safariextz'
  chrome: 'javascript:chrome.webstore.install()'

icon_class_by_browser =
  firefox: 'install-firefox'
  safari: 'install-safari'
  chrome: 'install-chrome'

window.ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'
  render: ->
    browserName = determineBrowser()
    extension_link = extension_link_by_browser[browserName]
    icon_class = icon_class_by_browser[browserName]
    extra_class = if @props.huge_button then 'button-huge' else null
    if document.documentElement.getAttribute('data-factlink-extension-loaded') != undefined
      _div [],
        _button ['button', extra_class,
          disabled: true],
          'Factlink already installed.'
    else
      _div [],
        _div ['visible-when-chrome'],
          _a ['button-success', extra_class, href: extension_link],
            _span [icon_class]
            'Install Factlink for ' + browserName.capitalize()
        _div ['visible-when-firefox'],
          _a ['button-success', extra_class, href: extension_link],
            _span [icon_class]
            'Install Factlink for ' + browserName.capitalize()
        _div ['visible-when-safari'],
          _a ['button-success', extra_class, href: extension_link],
            _span [icon_class]
            'Install Factlink for ' + browserName.capitalize()

