determineBrowser = ->
  [ 'chrome', 'firefox', 'safari', 'phantom_js', 'unsupported-browser' ]
  .filter( (browser) -> $('html.'+browser).length
  )[0]

extension_install_options_by_browser =
  firefox:
    href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'
    iconClass: 'install-firefox'
  safari:
    href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'
    iconClass: 'install-safari'
  chrome:
    href: 'javascript:chrome.webstore.install()'
    iconClass: 'install-chrome'

window.ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'
  render: ->
    browserName = determineBrowser()
    options = extension_install_options_by_browser[browserName]
    extra_class = if @props.huge_button then 'button-huge' else null
    if document.documentElement.getAttribute('data-factlink-extension-loaded') != undefined
      _button ['button', extra_class,
        disabled: true],
        'Factlink already installed.'
    else
      _a ['button-success', extra_class, href: options.href],
        _span [options.iconClass]
        'Install Factlink for ' + browserName.capitalize()
