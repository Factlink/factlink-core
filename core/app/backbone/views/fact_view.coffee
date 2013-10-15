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
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  tagName: "div"
  className: "fact-view"
  template: "facts/fact"

  templateHelpers: ->
    'modal?' : FactlinkApp.onClientApp is true

  regions:
    factBaseView: '.fact-base-region'
    linkRegion: '.js-fact-link-region'
    poparrowRegion: '.js-region-poparrow'

  initialize: (opts) ->
    @listenTo @model, "destroy", @close
    @listenTo @model, "change", @render

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model)
    @linkRegion.show @newLinkView()

    if Factlink.Global.signed_in
      @setPoparrow()

  newLinkView: ->
    new FactProxyLinkView
      model: @model

  setPoparrow: ->
    poparrowView = new FactPoparrowView model: @model
    @poparrowRegion.show poparrowView

  remove: -> @$el.fadeOut "fast", -> $(this).remove()

  highlight: ->
    @$el.animate
      "background-color": "#ffffe1"
    ,
      duration: 2000
      complete: -> $(this).animate "background-color": "#ffffff", 2000
