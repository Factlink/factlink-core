#= require ./generic/text_input_view
searchCollection = (type)->
  model = new Backbone.Model text: ''
  collection = new type()
  model.on 'change', -> collection.searchFor model.get('text')

  [model, collection]

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
    @_added_channels_view = new AutoCompletedAddedChannelsView
      collection: @collection
      mainView: this

    [@model, @search_collection] = searchCollection(TopicSearchResults)

    @_text_input_view = new TextInputView model: @model

    @filtered_search_collection = collectionDifference(TopicSearchResults,
      'slug_title', @search_collection, @collection)

    @_auto_completes_view = new AutoCompletesView
      mainView: this
      alreadyAdded: @collection
      model: @model
      collection: @filtered_search_collection

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
