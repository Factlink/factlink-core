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
        alert "Error while hiding Factlink from #{Factlink.Global.t.topic}"

      success: =>
        @model.collection.remove @model
        mp_track "Topic: Silence Factlink from Topic",
          factlink_id: @model.id
          channel_id: channel.id

  destroyFact: (e) ->
    e.preventDefault()
    @model.destroy
      wait: true
      error: -> alert "Error while removing the Factlink"
      success: -> mp_track "Factlink: Destroy"

class window.FactView extends Backbone.Marionette.Layout
  _.extend @prototype, Backbone.Factlink.PopoverMixin

  tagName: "div"
  className: "fact-view"
  template: "facts/fact"

  templateHelpers: ->
    'modal?' : FactlinkApp.modal is true

  regions:
    factBaseView: '.fact-base-region'
    factBottomView: '.fact-bottom-region'
    poparrowRegion: '.js-region-poparrow'

  initialize: (opts) ->
    @listenTo @model, "destroy", @close
    @listenTo @model, "change", @render

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model, truncate_body: true)
    @factBottomView.show @newFactBottomView()

    if Factlink.Global.signed_in
      @setPoparrow()

    @$(".authority").tooltip()

  newFactBottomView: ->
    new FactBottomView
      model: @model
      hide_discussion_link: @options.standalone
      show_timestamp: @options.standalone

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
