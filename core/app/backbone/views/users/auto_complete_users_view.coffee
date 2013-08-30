class window.AutoCompleteUsersView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-users"

  regions:
    'results': '.auto-complete-results-container'
    'search_list': '.auto-complete-search-list-container'
    'text_input': '.js-auto-complete-input-view-container'

  template: "auto_complete/box_with_results"

  initialize: ->
    @initializeChildViews
      filter_on: 'username'
      search_list_view: (options) -> new AutoCompleteSearchUsersView(options)
      search_collection: new UserSearchResults
      filtered_search_collection: new UserSearchResults
      placeholder: 'Type a name'

    @_results_view = new AutoCompleteResultsUsersView(collection: @collection)

  addCurrent: ->
    user = @_search_list_view.currentActiveModel()
    @collection.add user if user
    @model.set text: ''
