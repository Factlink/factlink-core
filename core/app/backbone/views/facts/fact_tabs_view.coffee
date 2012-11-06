class window.FactTabsView extends Backbone.Marionette.Layout
  template: "facts/fact_tabs"

  events:
    "click .tab-control .is-tab": "tabClick"

  regions:
    startConversationRegion: '.start-conversation .dropdown-container'

  initialize: ->
    @_currentTab = `undefined`
    @initFactRelationsViews()

  renderAddToChannel: ->
    add_el = ".tab-content .add-to-channel .dropdown-container .wrapper .add-to-channel-container"
    if @$(add_el).length > 0 and typeof currentUser isnt "undefined" and ("addToChannelView" not of this)
      addToChannelView = new AutoCompletedAddToChannelView
                               el: @$(add_el)[0]
                               collection: new OwnChannelCollection()
      _.each @model.getOwnContainingChannels(), (ch) ->
        addToChannelView.collection.add ch  if ch.get("type") is "channel"

      addToChannelView.on "addChannel", (channel) =>
        @model.addToChannel channel, {}

      addToChannelView.on "removeChannel", (channel) =>
        @model.removeFromChannel channel, {}
        @model.collection.remove @model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

      addToChannelView.render()
      @addToChannelView = addToChannelView

  onClose: -> @addToChannelView?.close()

  hideTabs: ->
    $tabButtons = @$el.find(".tab-control li")
    $tabButtons.removeClass "active"

    @$(".tab-content > div").hide()
    @$(".tab-control > li").removeClass "tabOpened"
    @_currentTab = `undefined`

  showTab: (tab, $tabHandle)->
    @hideTabs()
    @_currentTab = tab
    $tabHandle.addClass "active"
    @$(".tab-content > ." + tab).show()
    @$(".tab-control > li").addClass "tabOpened"
    @handleTabActions tab

  handleTabActions: (tab) ->
    mp_track "Factlink: Open tab",
      factlink_id: @model.id
      type: tab

    switch tab
      when "supporting", "weakening" then @showFactRelations tab
      when "add-to-channel" then @renderAddToChannel()
      when "start-conversation"
        @startConversationRegion.show new StartConversationView(model: @model)

  initFactRelationsViews: ->
    @supportingFactRelations = new SupportingFactRelations([],fact: @model)
    @weakeningFactRelations = new WeakeningFactRelations([],fact: @model)

  showFactRelations: (type) ->
    unless type + "FactRelationsView" of this
      this[type + "FactRelationsView"] = new FactRelationsView(collection: this[type + "FactRelations"])
      @$("." + type + " .dropdown-container").append this[type + "FactRelationsView"].render().el
    @$("." + type + " .dropdown-container").show()
    this[type + "FactRelationsView"].fetch()

  tabClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $target = $(e.target).closest("li")
    tab = $target.attr("class").split(" ")[0]
    if tab is @_currentTab
      @hideTabs()
    else
      @showTab(tab, $target)
