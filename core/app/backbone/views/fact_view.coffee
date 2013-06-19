#= require ./facts/fact_base_view
class FactPoparrowView extends Backbone.Factlink.PopArrowView
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
  _.extend @prototype, Backbone.Factlink.TooltipMixin

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
    @bindTo @model, "destroy", @close, @
    @bindTo @model, "change", @render, @

    if FactlinkApp.guided
      @tooltipAdd '.js-close',
        "First Factlink is created!",
        "You can close this up when you're done.",
        { side: 'right', align: 'top', margin: 8 }

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model)
    @factBottomView.show @newFactBottomView()

    if Factlink.Global.signed_in
      @setPoparrow()

    @$(".authority").tooltip()

    if FactlinkApp.guided
      sometimeWhen(
        => @$el.is ":visible"
      , =>
        @$('#close').tooltip(trigger: 'manual')
                    .tooltip('show')
      )

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
