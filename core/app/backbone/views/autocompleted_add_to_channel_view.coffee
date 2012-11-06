#= require ./generic/text_input_view

class AutocompleteSearchView extends Backbone.Marionette.Layout
  searchCollection: (type)->
    model = new Backbone.Model text: ''
    collection = new type()
    model.on 'change', -> collection.searchFor model.get('text')

    [model, collection]

  bindTextViewToSteppableViewAndSelf: (text_view, steppable_view)->
    @bindTo text_view, 'down', -> steppable_view.moveSelectionDown()
    @bindTo text_view, 'up',    -> steppable_view.moveSelectionUp()
    @bindTo text_view, 'return', @addCurrent, this

  addCurrent: ->
    console.error "the function to add current selection was not implemented"

class window.AutoCompletedAddToChannelView extends AutocompleteSearchView
  tagName: "div"
  className: "add-to-channel"
  events:
    "click div.auto_complete": "addCurrent"

  regions:
    'added_channels': 'div.added_channels_container'
    'auto_completes': 'div.auto_complete_container'
    'input': 'div.fake-input'

  template: "channels/auto_completed_add_to_channel"

  initialize: ->
    @_added_channels_view = new AutoCompletedAddedChannelsView
      collection: @collection

    [@model, @search_collection] = @searchCollection(TopicSearchResults)

    @_text_input_view = new TextInputView model: @model

    @filtered_search_collection = collectionDifference(TopicSearchResults,
      'slug_title', @search_collection, @collection)

    @_auto_completes_view = new AutoCompletesView
      model: @model
      collection: @filtered_search_collection

    @bindTextViewToSteppableViewAndSelf(@_text_input_view, @_auto_completes_view)

  onRender: ->
    @added_channels.show @_added_channels_view
    @auto_completes.show @_auto_completes_view
    @input.show @_text_input_view

  addCurrent: ->
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
