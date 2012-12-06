class window.AutoCompleteChannelsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-channels"

  events:
    "click div.auto-complete-search-list": "addCurrent"

  regions:
    'suggestionRegion': '.suggestion-region'
    'results': 'div.auto-complete-results-container'
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.auto-complete-input-container'

  template: "auto_complete/box_with_results"

  initialize: (options) ->
    @site_id = options.site_id

    @initializeChildViews
      filter_on: 'slug_title'
      search_list_view: (options) -> new AutoCompleteSearchChannelsView(options)
      search_collection: -> new TopicSearchResults
      placeholder: -> Factlink.Global.t.channel_name.capitalize()

    @_results_view = new AutoCompleteResultsChannelsView(collection: @collection)

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
        @trigger 'error', 'create_channel'
        afterAdd()

  addNewChannel: (channel) ->
    # create new object if the current channel is already in a collection
    channel = channel.clone() if channel.collection?
    @collection.add channel

  disable: ->
    @$el.addClass("disabled")
    @_text_input_view.disable()

  enable: ->
    @$el.removeClass("disabled")
    @_text_input_view.enable()
