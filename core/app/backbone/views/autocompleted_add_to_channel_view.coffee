#= require_tree ./generic

class window.AutoCompletedAddToChannelView extends AutoCompleteSearchView
  tagName: "div"
  className: "add-to-channel"
  events:
    "click div.auto_complete": "addCurrent"

  regions:
    'added_channels': 'div.added_channels_container'
    'auto_completes': 'div.auto_complete_container'
    'input': 'div.fake-input'

  template: "channels/auto_completed_add_to_channel"

  auto_complete_search_view_options:
    filter_on: 'slug_title'
    results_view: AutoCompletedAddedChannelsView
    search_collection: TopicSearchResults
    auto_completes_view: AutoCompletesView

  initialize: ->
    @initialize_child_views @auto_complete_search_view_options
    @_results_view.on "itemview:remove",  (childView, msg) =>
      @trigger 'removeChannel', childView.model

  onRender: ->
    @added_channels.show @_results_view
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
