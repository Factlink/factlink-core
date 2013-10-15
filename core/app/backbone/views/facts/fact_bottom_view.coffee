class window.FactBottomView extends Backbone.Marionette.ItemView
  className: 'fact-bottom'

  template: 'facts/fact_bottom'

  events:
    "click .js-open-proxy-link" : "openProxyLink"

  openProxyLink: (e) ->
    mp_track "Factlink: Open proxy link",
      site_url: @model.get("fact_url")
