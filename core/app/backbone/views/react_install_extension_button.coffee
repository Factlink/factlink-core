determineBrowser = ->
  [ 'chrome', 'firefox', 'safari' ]
  .filter( (browser) -> $('html.'+browser).length
  )[0]

extension_install_options_by_browser =
  firefox:
    href: 'https://factlink.github.io/browser-extensions/firefox/factlink-extension.xpi'
    iconClass: 'firefox-icon'
  safari:
    href: 'https://factlink.github.io/browser-extensions/safari/factlink.safariextz'
    iconClass: 'safari-icon'
  chrome:
    href: 'javascript:chrome.webstore.install()'
    iconClass: 'chrome-icon'

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
  componentWillMount: ->
    check = =>
      @setState(
        extension_installed:
          document.documentElement.getAttribute('data-factlink-extension-loaded')?
      )
    document.addEventListener('readystatechange', check)
    check()

  render: ->
    browserName = determineBrowser()
    extra_class = if @props.huge_button then 'button-huge' else null

    if !browserName && !@state.extension_installed && @props.huge_button
      _div ['bookmarklet-install-block'],
        _div ['in-your-browser-dashed-border'],
          _a ["in-your-browser-bookmarklet",
              "button-success", "button-huge",
              href: Factlink.Global.bookmarklet_link
              onClick: ((e)-> e.preventDefault())],
            _span [style: display: 'none'], 'Factlink'
        _div [],
          _em [],
            'To install Factlink, drag this button to your bookmarks bar'
    else if @props.huge_button && @state.extension_installed
      _button ['button', 'button-huge',
        disabled: true],
        'Factlink has been installed!'
    else if (@state.extension_installed || !browserName) && !@props.huge_button
      _div [] # nothing.
    else
      ReactInstallExtensionButton
        extra_class: extra_class
