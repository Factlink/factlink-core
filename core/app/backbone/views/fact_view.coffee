ViewWithPopover = extendWithPopover(Backbone.Factlink.PlainView)

class window.FactView extends ViewWithPopover
  tagName: "div"
  className: "fact-block"

  events:
    "click .hide-from-channel": "removeFactFromChannel"
    "click li.delete": "destroyFact"
    "click .tab-control .supporting": "tabClick"
    "click .tab-control .weakening": "tabClick"
    "click .tab-control .add-to-channel": "tabClick"
    "click a.more": "showCompleteDisplaystring"
    "click a.less": "hideCompleteDisplaystring"

  template: "facts/_fact"

  partials:
    fact_bubble: "facts/_fact_bubble"
    fact_wheel: "facts/_fact_wheel"
    interacting_users: "facts/_interacting_users"

  interactingUserViews: []

  popover: [
    selector: ".top-right-arrow"
    popoverSelector: "ul.top-right"
  ]

  showLines: 3

  initialize: (opts) ->
    @_currentTab = `undefined`
    @interactingUserViews = []
    @model.bind "destroy", @close, this
    @model.bind "change", @render, this
    @initFactRelationsViews()
    @wheel = new Wheel(@model.getFactWheel())

  onRender: ->
    sometimeWhen(
      => this.$el.is ":visible"
      ,
      => this.truncateText()
    )

    @$(".authority").tooltip()
    if @factWheelView
      @wheel.set @model.getFactWheel()
      @$(".wheel").replaceWith @factWheelView.reRender().el
    else
      @factWheelView = new InteractiveWheelView(
        model: @wheel
        fact: @model
        el: @$(".wheel")
      ).render()

  truncateText: ->
    @$(".body .text").trunk8
      fill: " <a class=\"more\">(more)</a>"
      lines: @showLines

  remove: ->
    @$el.fadeOut "fast", -> $(this).remove()

    _.each @interactingUserViews, (view)-> view.close()

    @addToChannelView.close() if @addToChannelView
    if parent.remote
      parent.remote.hide()
      parent.remote.stopHighlightingFactlink @model.id

  removeFactFromChannel: (e) ->
    e.preventDefault()
    self = this
    @model.removeFromChannel currentChannel,
      error: ->
        alert "Error while hiding Factlink from Channel"

      success: ->
        self.model.collection.remove self.model
        mp_track "Channel: Silence Factlink from Channel",
          factlink_id: self.model.id
          channel_id: currentChannel.id

  destroyFact: (e) ->
    e.preventDefault()
    @model.destroy
      error: -> alert "Error while removing the Factlink"
      success: -> mp_track "Factlink: Destroy"

  renderAddToChannel: ->
    self = this
    add_el = ".tab-content .add-to-channel .dropdown-container .wrapper .add-to-channel-container"
    if @$(add_el).length > 0 and typeof currentUser isnt "undefined" and ("addToChannelView" not of this)
      addToChannelView = new AutoCompletedAddToChannelView(el: @$(add_el)[0])
      _.each @model.getOwnContainingChannels(), (ch) ->
        addToChannelView.collection.add ch  if ch.get("type") is "channel"

      addToChannelView.on "addChannel", (channel) ->
        self.model.addToChannel channel, {}

      addToChannelView.on "removeChannel", (channel) ->
        self.model.removeFromChannel channel, {}
        self.model.collection.remove self.model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

      addToChannelView.render()
      @addToChannelView = addToChannelView

  initFactRelationsViews: ->
    @supportingFactRelations = new SupportingFactRelations([],fact: @model)
    @weakeningFactRelations = new WeakeningFactRelations([],fact: @model)

  switchToRelationDropdown: (type) ->
    mp_track "Factlink: Open tab",
      factlink_id: @model.id
      type: type

    if type is "supporting"
      @hideFactRelations "weakening"
      @showFactRelations "supporting"
    else
      @hideFactRelations "supporting"
      @showFactRelations "weakening"

  showFactRelations: (type) ->
    unless type + "FactRelationsView" of this
      this[type + "FactRelationsView"] = new FactRelationsView(collection: this[type + "FactRelations"])
      @$("." + type + " .dropdown-container").append this[type + "FactRelationsView"].render().el
    @$("." + type + " .dropdown-container").show()
    this[type + "FactRelationsView"].fetch()

  hideFactRelations: (type) ->
    @$("." + type + " .dropdown-container").hide()

  tabClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $target = $(e.target).closest("li")
    tab = $target.attr("class").split(" ")[0]
    $tabButtons = @$el.find(".tab-control li")
    $tabButtons.removeClass "active"
    if tab isnt @_currentTab
      @_currentTab = tab
      @hideTabs()
      $target.addClass "active"
      @$(".tab-content > ." + tab).show()
      @$(".tab-control > li").addClass "tabOpened"
      @handleTabActions tab
    else
      @hideTabs()
      @_currentTab = `undefined`

  hideTabs: ->
    @$(".tab-content > div").hide()
    @$(".tab-control > li").removeClass "tabOpened"

  handleTabActions: (tab) ->
    switch tab
      when "supporting", "weakening"
        @switchToRelationDropdown tab
      when "add-to-channel"
        @renderAddToChannel()

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
