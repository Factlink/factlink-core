class TextInputView extends Backbone.Marionette.ItemView
  events:
    'click': 'focusInput'
    "keydown input.typeahead": "parseKeyDown"
    "keyup input.typeahead": "autoCompleteCurrentValue"

  template:
    text: '<input type="text" value="{{text}}" class="typeahead">'

  initialize: ->
    @model.on 'change', @updateValue, this

  focusInput: -> @$("input.typeahead").focus()

  parseKeyDown: (e) ->
    eventHandled = false
    switch e.keyCode
      when 13 then @trigger 'return'
      when 40 then @trigger 'down'
      when 38 then @trigger 'up'
      when 27 then @trigger 'escape'
      else eventHandled = true

    unless eventHandled
      e.preventDefault()
      e.stopPropagation()

  updateValue: ->
    @$("input.typeahead").val(@model.get('text'))

  autoCompleteCurrentValue: ->
    searchValue = @$("input.typeahead").val()
    @model.set(text: searchValue)

  enable: ->
    @$("input.typeahead").prop "disabled", false

  disable: ->
    @$("input.typeahead").prop "disabled", true

class window.AutoCompletedAddToChannelView extends Backbone.Marionette.Layout
  tagName: "div"
  className: "add-to-channel"
  events:
    "click div.auto_complete": "addCurrentlySelectedChannel"

  regions:
    'added_channels': 'div.added_channels_container'
    'auto_completes': 'div.auto_complete_container'
    'input': 'div.fake-input'

  template: "channels/_auto_completed_add_to_channel"

  initialize: ->
    @collection = new OwnChannelCollection()
    @_added_channels_view = new AutoCompletedAddedChannelsView
      collection: @collection
      mainView: this
    @_auto_completes_view = new AutoCompletesView
      mainView: this
      alreadyAdded: @collection

    @model = new Backbone.Model text: ''
    @model.on 'change', => @autoCompleteCurrentValue()
    @_text_input_view = new TextInputView model: @model

    @_text_input_view.on 'return', => @addCurrentlySelectedChannel()
    @_text_input_view.on 'down', => @_auto_completes_view.moveSelectionDown()
    @_text_input_view.on 'up', => @_auto_completes_view.moveSelectionUp()

  onRender: ->
    @added_channels.show @_added_channels_view
    @auto_completes.show @_auto_completes_view
    @input.show @_text_input_view

  addCurrentlySelectedChannel: ->
    @disable()
    afterAdd = =>
      @model.set text:''
      @enable()

    activeTopic = @_auto_completes_view.currentActiveModel()

    if not activeTopic
      afterAdd()
      return

    @model.set text: activeTopic.get("title")

    activeTopic.withCurrentOrCreatedChannelFor currentUser,
      success: (ch)=>
        @addNewChannel ch
        afterAdd()
      error: =>
        alert "Something went wrong while adding the fact to this channel, sorry"
        afterAdd()

  addNewChannel: (channel) ->
    @trigger "addChannel", channel
    # create new object if the current channel is already in a collection
    channel = new Channel(channel.toJSON()) if channel.collection?
    @collection.add channel

  disable: ->
    @$el.addClass("disabled")
    @_text_input_view.disable()

  enable: ->
    @$el.removeClass("disabled")
    @_text_input_view.enable()

  autoCompleteCurrentValue: ->
    searchValue = @model.get('text')
    @_auto_completes_view.search_collection.searchFor searchValue
