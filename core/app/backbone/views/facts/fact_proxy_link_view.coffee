class window.FactProxyLinkView extends Backbone.Marionette.ItemView
  className: 'proxy-link-container'

  template: 'facts/proxy_link'

  events:
    "click .js-open-proxy-link" : "openProxyLink"

  openProxyLink: (e) ->
    mp_track "Factlink: Open proxy link",
      site_url: @model.get("fact_url")
