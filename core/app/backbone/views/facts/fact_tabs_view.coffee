class window.FactTabsView extends Backbone.Marionette.Layout
  template: "facts/fact_tabs"

  events:
    "click .tab-control .is-tab": "tabClick",
    "click .tab-control .is-popup": "popupClick",
    "click .transparent-layer": "closePopup",
    "click .popup-content .close-popup": "closePopup"

  regions:
    startConversationRegion: '.popup-content .start-conversation-container'
    addToChannelRegion: ".popup-content .add-to-channel-form"

  initialize: ->
    @_currentTab = `undefined`
    @initFactRelationsViews()

  renderAddToChannel: ->
    if @addToChannelView == `undefined`
      @addToChannelView = new AutoCompleteChannelsView
                               collection: new OwnChannelCollection()
      _.each @model.getOwnContainingChannels(), (ch) =>
        @addToChannelView.collection.add ch  if ch.get("type") is "channel"

      @addToChannelView.on "addChannel", (channel) =>
        @model.addToChannel channel, {}

      @addToChannelView.on "removeChannel", (channel) =>
        @model.removeFromChannel channel, {}
        @model.collection.remove @model  if window.currentChannel and currentChannel.get("id") is channel.get("id")

      @addToChannelRegion.show @addToChannelView

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
      when "doubting", "supporting", "weakening" then @showFactRelations tab

  initFactRelationsViews: ->
    @supportingFactRelations = new SupportingFactRelations([],fact: @model)
    @weakeningFactRelations = new WeakeningFactRelations([],fact: @model)

  showFactRelations: (type) ->
    unless type + "FactRelationsView" of this
      if type == "doubting"
        this[type + "FactRelationsView"] = new DoubtingRelationsView()
      else
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

  popupClick: (e) ->
    e.preventDefault()
    e.stopPropagation()
    $target = $(e.target).closest("li")
    popup = $target.attr("class").split(" ")[0]

    @showPopup(popup)

  showPopup: (popup) ->
    @$('.popup-content .' + popup + '-container').show()

    @$('.transparent-layer').show()

    switch popup
      when "start-conversation"
        @startConversationRegion.show new StartConversationView(model: @model)
      when "add-to-channel" then @renderAddToChannel()

  closePopup: (e) ->
    @$('.popup-content > div').hide()
    @$('.transparent-layer').hide()
