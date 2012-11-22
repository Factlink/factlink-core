class window.AutoCompleteChannelsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-channels"

  events:
    "click div.auto-complete-search-list": "addCurrent"

  regions:
    'results': 'div.auto-complete-results-container'
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.auto-complete-input-container'

  template: "auto_complete/box_with_results"

  initialize: ->
    @initializeChildViews
      filter_on: 'slug_title'
      search_list_view: (options) -> new AutoCompleteSearchChannelsView(options)
      search_collection: -> new TopicSearchResults
      placeholder: -> Factlink.Global.t.channel_name.capitalize()

    @_results_view = new AutoCompleteResultsChannelsView(collection: @collection)
    @_results_view.on "itemview:remove",  (childView, msg) =>
      @trigger 'removeChannel', childView.model

  addCurrent: ->
    @disable()
    afterAdd = =>
      @model.set text: ''
      @enable()

    activeTopic = @_search_list_view.currentActiveModel()

    if not activeTopic
      afterAdd()
      return

    activeTopic.withCurrentOrCreatedChannelFor currentUser,
      success: (ch)=>
        @addNewChannel ch
        afterAdd()
      error: =>
        alert "Something went wrong while adding the Factlink to this channel, sorry"
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
