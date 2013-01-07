class window.FactsNewView extends Backbone.Marionette.ItemView
  template: "client/facts_new"

  templateHelpers: ->
    layout: @options.layout
    fact_text: @options.fact_text
    title: @options.title
    url: @options.url
    add_to_channel_header: Factlink.Global.t.add_to_channels.capitalize()
    csrf_token: @options.csrf_token
