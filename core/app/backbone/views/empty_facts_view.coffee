class window.EmptyFactsView extends Backbone.Marionette.ItemView
  template: 'channels/no_facts'

  className: 'channel-empty-facts'

  events:
    "click .download-chrome-extension": "downloadChromeExtension"

  initialize: ->
    if @model.get('is_normal')
      @relatedChannelsView = new RelatedChannelsView(model: @model)

  onRender: ->
    if @relatedChannelsView
      @relatedChannelsView.render()
      @$('.related-channels').html(@relatedChannelsView.el)

  onClose: -> @relatedChannelsView?.close()

  downloadChromeExtension: ->
    use_chrome_webstore = Factlink.Global.use_chrome_webstore
    if use_chrome_webstore
      chrome.webstore.install()
    else
      document.location = Factlink.Global.chrome_extension_url
