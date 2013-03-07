#= require ./facts/fact_base_view
class FactPopoverView extends Backbone.Factlink.PopoverView
  template: 'facts/popover'

  events:
    "click .hide-from-channel": "removeFactFromChannel"
    "click li.delete": "destroyFact"

  removeFactFromChannel: (e) ->
    e.preventDefault()
    @model.removeFromChannel currentChannel,
      error: ->
        alert "Error while hiding Factlink from Channel"

      success: =>
        @model.collection.remove @model
        mp_track "Channel: Silence Factlink from Channel",
          factlink_id: @model.id
          channel_id: currentChannel.id

  destroyFact: (e) ->
    e.preventDefault()
    @model.destroy
      wait: true
      error: -> alert "Error while removing the Factlink"
      success: -> mp_track "Factlink: Destroy"

class window.FactView extends Backbone.Marionette.Layout
  tagName: "div"
  className: "fact-view"

  events:
    "click a.discussion_link" : "triggerDiscussionClick"

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

    if FactlinkApp.guided
      tooltip_view = new PopoverView(model: new Backbone.Model(title: 'Title', text: 'Hi my name is popover.'))
      @tooltipAdd '.js-close', 'Title', 'Hi my name is popover', { side: 'bottom', align: 'left' }

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model)
    @factBottomView.show new FactBottomView(model: @model)

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

  triggerDiscussionClick: (e) ->
    FactlinkApp.vent.trigger 'factlink_permalink_clicked', e, @model

_.extend window.FactView.prototype, Backbone.Factlink.TooltipMixin
