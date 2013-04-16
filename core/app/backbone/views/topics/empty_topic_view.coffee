class window.EmptyTopicView extends Backbone.Marionette.ItemView
  tagName: 'p'
  className: 'topic-empty'
  template: 'topics/empty'

  events:
    "click .js-download-chrome-extension": "downloadChromeExtension"

  downloadChromeExtension: ->
    use_chrome_webstore = Factlink.Global.use_chrome_webstore
    if use_chrome_webstore
      chrome.webstore.install()
    else
      document.location = Factlink.Global.chrome_extension_url
