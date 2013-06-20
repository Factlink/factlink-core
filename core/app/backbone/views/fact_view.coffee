#= require ./facts/fact_base_view
class FactPopoverView extends Backbone.Factlink.PopoverView
  template: 'facts/popover'

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
    popoverRegion: '.js-region-popover'

  initialize: (opts) ->
    @bindTo @model, "destroy", @close, @
    @bindTo @model, "change", @render, @

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model)
    @factBottomView.show @newFactBottomView()

    if Factlink.Global.signed_in
      @setPopover()

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

  setPopover: ->
    popoverView = new FactPopoverView model: @model
    @popoverRegion.show popoverView

  remove: -> @$el.fadeOut "fast", -> $(this).remove()

  highlight: ->
    @$el.animate
      "background-color": "#ffffe1"
    ,
      duration: 2000
      complete: -> $(this).animate "background-color": "#ffffff", 2000
