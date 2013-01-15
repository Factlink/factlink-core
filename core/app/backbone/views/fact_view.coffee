#= require ./facts/fact_base_view

ViewWithPopover = extendWithPopover(Backbone.Marionette.Layout)

class window.FactView extends ViewWithPopover
  tagName: "div"
  className: "fact-view"

  events:
    "click .hide-from-channel": "removeFactFromChannel"
    "click li.delete": "destroyFact"
    "click a.discussion_link" : "triggerDiscussionClick"

  template: "facts/_fact"

  regions:
    factBaseView: '.fact-base-region'
    factBottomView: '.fact-bottom-region'

  popover: [
    selector: ".top-right-arrow"
    popoverSelector: "ul.top-right"
  ]

  initialize: (opts) ->
    @bindTo @model, "destroy", @close, @
    @bindTo @model, "change", @render, @

  onRender: ->
    @factBaseView.show new FactBaseView(model: @model)
    @factBottomView.show new FactBottomView(model: @model)

    @$(".authority").tooltip()
    if FactlinkApp.guided
      sometimeWhen(
        => @$el.is ":visible"
      , =>
        @$('#close').tooltip(trigger: 'manual')
                    .tooltip('show')
      )

  remove: -> @$el.fadeOut "fast", -> $(this).remove()

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

  highlight: ->
    @$el.animate
      "background-color": "#ffffe1"
    ,
      duration: 2000
      complete: -> $(this).animate "background-color": "#ffffff", 2000

  triggerDiscussionClick: (e) ->
    FactlinkApp.vent.trigger 'factlink_permalink_clicked', e, @model
