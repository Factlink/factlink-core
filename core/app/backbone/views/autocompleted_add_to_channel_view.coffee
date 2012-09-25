updateWindowHeight = ->  window.updateHeight() if window.updateHeight

class window.AutoCompletedAddToChannelView extends Backbone.Factlink.PlainView
  tagName: "div"
  className: "add-to-channel"
  events:
    "keydown input.typeahead": "parseKeyDown"
    "keyup input.typeahead": "autoComplete"
    "focus input.typeahead": "onFocusInput"
    "click div.fake-input": "focusInput"
    "click div.auto_complete": "parseReturn"
    "click div.fake-input a": "parseReturn"
    "blur input.typeahead": "blurInput"
    "click .show-input-button": "showInput"
    "mouseenter .auto_complete>div": "selectAddNew"
    "mouseleave .auto_complete>div": "deActivateAddNew"

  activeChannelKey: -> @_activeChannelKey

  setActiveChannelKey: (value) -> @_activeChannelKey = value

  template: "channels/_auto_completed_add_to_channel"

  initialize: ->
    @vent = new Backbone.Marionette.EventAggregator()
    @collection = new OwnChannelCollection()
    @_added_channels_view = new AutoCompletedAddedChannelsView(
      collection: @collection
      mainView: this
    )
    @_auto_completes_view = new AutoCompletesView(mainView: this)

    @collection.on "remove", (ch) => @onRemoveChannel ch
    @collection.on "add", (ch) => @onAddChannel ch

  onRemoveChannel: (ch) ->
    if @collection.length
      @$el.addClass "hide-input"
    else
      @$el.removeClass "hide-input"

  onAddChannel: (ch) ->
    @$el.addClass "hide-input"
    updateWindowHeight()

  onRender: ->
    @$el.find(".auto_complete ul").preventScrollPropagation()
    @_added_channels_view.render()
    @$el.find("div.added_channels_container").html @_added_channels_view.el
    updateWindowHeight()

  parseKeyDown: (e) ->
    @_proceed = false
    switch e.keyCode
      when 13 then @parseReturn e
      when 40 then @_auto_completes_view.moveSelectionDown e
      when 38 then @_auto_completes_view.moveSelectionUp e
      when 27 then @hideAutoComplete()
      else @_proceed = true

  showInput: -> @$el.removeClass("hide-input").find(".fake-input input").focus()

  focusInput: -> @$("input.typeahead").focus()
  onFocusInput: -> @$el.addClass "focus"
  blurInput: -> @$el.removeClass "focus"

  deActivateCurrent: ->
    @_auto_completes_view.deActivateCurrent()
    @deActivateAddNew()

  setActiveAutoComplete: (key, scroll) ->
    @_auto_completes_view.setActiveAutoComplete key, scroll

  selectAddNew: ->
    return false  unless @isAddNewVisible()
    @deActivateAutoCompleteView()  if typeof @activeChannelKey() is "number"
    @activateAddNew()

  activateAddNew: -> @$(".auto_complete>div").addClass "active"
  deActivateAddNew: -> @$(".auto_complete>div").removeClass "active"
  isAddNewActive: -> @$(".auto_complete>div").hasClass "active"

  activateAutoCompleteView: (view) ->
    @setActiveAutoComplete @_auto_completes_view.list.indexOf(view)

  deActivateAutoCompleteView: ->
    activeview = @_auto_completes_view.list[@activeChannelKey()]
    activeview.trigger "deactivate"  if activeview isnt `undefined`
    @setActiveChannelKey `undefined`

  parseReturn: (e) ->
    e.preventDefault()
    e.stopPropagation()
    @disable()
    if 0 <= @activeChannelKey() < @_auto_completes_view.list.length
      selected = @_auto_completes_view.list[@activeChannelKey()].model
      @$("input.typeahead").val selected.get("title")
      if selected.get("user_channel")
        @addNewChannel selected.get("user_channel")
        return
    @createNewChannel e

  isDupe: (title) -> @collection.where(title: title).length > 0

  completelyDisappear: ->
    @hideAutoComplete()
    @enable()
    @hideLoading()
    @clearInput()

  createNewChannel: (e) ->
    title = @$("input.typeahead").val()
    title = $.trim(title)
    dupe = false
    @showLoading()
    if (title.length < 1) or (@isDupe(title))
      @completelyDisappear()
      return
    to_create_user_channels = @_auto_completes_view.collection.filter((item) ->
      item.get("title") is title and item.get("user_channel")
    )
    if to_create_user_channels.length > 0
      @addNewChannel to_create_user_channels[0].get("user_channel")
      return
    $.ajax(
      url: "/" + currentUser.get("username") + "/channels"
      data:
        title: title

      type: "POST"
    ).done _.bind(@addNewChannel, this)
    e.preventDefault()

  addNewChannel: (channel) ->
    channel = new Channel(channel)
    currentUser.channels.add channel
    @vent.trigger "addChannel", channel
    @collection.add channel
    @completelyDisappear()

  clearInput: ->
    @$("input.typeahead").val ""
    @$el.addClass "hide-input"  if @collection.length

  disable: ->
    @$el.addClass("disabled").find("input.typeahead").prop "disabled", true
    @$(".btn").addClass "disabled"

  enable: ->
    @$el.removeClass("disabled").find("input.typeahead").prop "disabled", false
    @$(".btn").removeClass "disabled"

  showLoading: -> @$(".loading").show()
  hideLoading: -> @$(".loading").hide()

  updateText: ->
    value = @$el.find("input.typeahead").val()
    if value.length
      @$el.addClass "has-text"
      @$(".search").text value
    else
      @$el.removeClass "has-text"

  autoComplete: _.debounce(->
    searchValue = @$("input.typeahead").val()
    @updateText()

    return  if @_lastKnownSearchValue is searchValue or not @_proceed

    @_lastKnownSearchValue = searchValue
    @setActiveChannelKey `undefined`

    if searchValue.length < 1
      @hideAutoComplete()
      return

    @showLoading()
    @clearAutoComplete()
    @_auto_completes_view.collection.setSearch searchValue
    @_auto_completes_view.collection.fetch success: =>
      @showAutoComplete()
      @setActiveAutoComplete 0, false
      updateWindowHeight()
  , 300)

  hideAddNew: -> @$el.addClass "hide-add-new"
  showAddNew: -> @$el.removeClass "hide-add-new"
  isAddNewVisible: -> not @$el.hasClass("hide-add-new")

  hideAutoComplete: -> @$(".auto_complete").hide()
  showAutoComplete: -> @$(".auto_complete").show()

  clearAutoComplete: ->
    @_auto_completes_view.closeList()
    @_auto_completes_view.collection.reset []
    @$(".auto_complete").addClass "empty"
    @hideAutoComplete()
    @deActivateAddNew()
    @showAddNew()

  onClose: -> @_auto_completes_view.close()