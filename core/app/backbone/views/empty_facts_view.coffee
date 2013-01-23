class window.EmptyFactsView extends Backbone.Marionette.ItemView
  template: 'channels/no_facts'

  className: 'channel-empty-facts'

  events:
    "click .download-chrome-extension": "downloadChromeExtension"

  templateHelpers: =>
    is_mine: this.model.get('created_by').username == currentUser.get('username')

  downloadChromeExtension: ->
    use_chrome_webstore = Factlink.Global.use_chrome_webstore
    if use_chrome_webstore
      chrome.webstore.install()
    else
      document.location = Factlink.Global.chrome_extension_url
