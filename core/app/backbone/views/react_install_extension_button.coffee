determineBrowser = ->
  [ 'chrome', 'firefox', 'safari' ]
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

ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'
  render: ->
    browserName = determineBrowser()
    options = extension_install_options_by_browser[browserName]
    _a ['button-success', @props.extra_class, href: options.href],
      _span [options.iconClass]
      'Install Factlink for ' + browserName.capitalize()

window.ReactInstallExtensionOrBookmarklet = React.createClass
  displayName: 'ReactInstallExtensionOrBookmarklet'
  render: ->
    extension_installed = document.documentElement.getAttribute('data-factlink-extension-loaded')?
    browserName = determineBrowser()
    extra_class = if @props.huge_button then 'button-huge' else null

    if !browserName && !extension_installed && @props.huge_button
      _div ['bookmarklet-install-block'],
        _div ['in-your-browser-dashed-border'],
          _a ["js-bookmarklet-button", "in-your-browser-bookmarklet",
              "button-success", "button-huge",
              onclick: ((e)-> e.preventDefault())],
            _span [style: display: 'none'], 'Factlink'
        _div [],
          _em [],
            'To install Factlink, drag this button to your bookmarks bar'
    else if @props.huge_button && extension_installed
      _button ['button', 'button-huge',
        disabled: true],
        'Factlink already installed.'
    else if (extension_installed || !browserName) && !@props.huge_button
      _div [], # nothing.
    else
      ReactInstallExtensionButton
        extra_class: extra_class
