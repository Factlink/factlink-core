class window.AutoCompleteChannelsView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-channels"

  regions:
    'results': 'div.auto-complete-results-container'
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.js-auto-complete-input-view-container'

  template: "auto_complete/box_with_results"

  initialize: (options) ->
    @initializeChildViews
      filter_on: 'slug_title'
      search_list_view: (options) -> new AutoCompleteSearchChannelsView(options)
      search_collection: -> new TopicSearchResults [], user: currentUser
      placeholder: -> 
        Factlink.Global.t.topic_name.capitalize()
        
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
