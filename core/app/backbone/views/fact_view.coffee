#= require ./facts/fact_base_view
class FactPoparrowView extends Backbone.Factlink.PoparrowView
  template: 'facts/poparrow'

  events:
    "click .hide-from-channel": "removeFactFromChannel"
    "click li.delete": "destroyFact"

  removeFactFromChannel: (e) ->
    e.preventDefault()
    channel = @model.collection.channel
    @model.removeFromChannel channel,
      error: ->
        FactlinkApp.NotificationCenter.error "Error while hiding Factlink from #{Factlink.Global.t.topic}"

      success: =>
        @model.collection.remove @model
        mp_track "Topic: Silence Factlink from Topic",
          factlink_id: @model.id
          channel_id: channel.id

  destroyFact: (e) ->
    e.preventDefault()
    @model.destroy
      wait: true
      error: -> FactlinkApp.NotificationCenter.error "Error while removing the Factlink"
      success: -> mp_track "Factlink: Destroy"

class window.FactView extends Backbone.Marionette.Layout
  className: "fact-view"
  template: "facts/fact"

  regions:
    factBaseRegion: '.js-fact-base-region'
    linkRegion: '.js-fact-link-region'
    poparrowRegion: '.js-region-poparrow'

  initialize: (opts) ->
    @listenTo @model, "destroy", @close
    @listenTo @model, "change", @render

  onRender: ->
    @factBaseRegion.show new FactBaseView(model: @model)

    if @model.get('proxy_scroll_url')
      @linkRegion.show new FactProxyLinkView model: @model

    if Factlink.Global.signed_in
      @poparrowRegion.show new FactPoparrowView model: @model

  remove: -> @$el.fadeOut "fast", -> $(this).remove()
