ViewWithPopover = extendWithPopover(Backbone.Factlink.PlainView)

class window.FactView extends ViewWithPopover
  tagName: "div"
  className: "fact-view"

  events:
    "click .hide-from-channel": "removeFactFromChannel"
    "click li.delete": "destroyFact"
    "click a.more": "showCompleteDisplaystring"
    "click a.less": "hideCompleteDisplaystring"
    "click a.discussion_link" : "triggerDiscussionClick"

  template: "facts/_fact"

  partials:
    fact_base: "facts/_fact_base"
    fact_wheel: "facts/_fact_wheel"

  popover: [
    selector: ".top-right-arrow"
    popoverSelector: "ul.top-right"
  ]

  showLines: 3

  initialize: (opts) ->
    @model.bind "destroy", @close, this
    @model.bind "change", @render, this
    @wheel = new Wheel(@model.getFactWheel())
    @bottomView = new FactBottomView(model: @model)

  onRender: ->
    sometimeWhen(
      => @$el.is ":visible"
      ,
      => @truncateText()
    )

    @bottomView.render()
    @$el.append(@bottomView.el)

    @wheel.set @model.getFactWheel()

    unless @factWheelView?
      @factWheelView = new InteractiveWheelView(
        model: @wheel
        fact: @model
      )
      @$(".fact-wheel").html(@factWheelView.$el)
      @$(".authority").tooltip()
    @factWheelView.render()

  truncateText: ->
    @$(".body .text").trunk8
      fill: " <a class=\"more\">(more)</a>"
      lines: @showLines

  remove: ->
    @$el.fadeOut "fast", -> $(this).remove()

    if parent.remote
      parent.remote.hide()
      parent.remote.stopHighlightingFactlink @model.id

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
      error: -> alert "Error while removing the Factlink"
      success: -> mp_track "Factlink: Destroy"

  highlight: ->
    @$el.animate
      "background-color": "#ffffe1"
    ,
      duration: 2000
      complete: -> $(this).animate "background-color": "#ffffff", 2000

  showCompleteDisplaystring: (e) ->
    @$(".body .text").trunk8 lines: 199
    @$(".body .less").show()

  hideCompleteDisplaystring: (e) ->
    @$(".body .text").trunk8 lines: @showLines
    @$(".body .less").hide()

  triggerDiscussionClick: (e) ->
    FactlinkApp.vent.trigger 'factlink_permalink_clicked', e, @model
