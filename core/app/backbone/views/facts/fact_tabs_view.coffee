class window.FactTabsView extends Backbone.Marionette.ItemView
  template: "facts/fact_tabs"

  events:
    "click .tab-control .supporting": "tabClick"
    "click .tab-control .weakening": "tabClick"
    "click .tab-control .add-to-channel": "tabClick"

  initialize: ->
    @_currentTab = `undefined`
    @initFactRelationsViews()

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

  onClose: ->
    @addToChannelView.close() if @addToChannelView

  hideTabs: ->
    @$(".tab-content > div").hide()
    @$(".tab-control > li").removeClass "tabOpened"

  handleTabActions: (tab) ->
    switch tab
      when "supporting", "weakening"
        @switchToRelationDropdown tab
      when "add-to-channel"
        @renderAddToChannel()

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