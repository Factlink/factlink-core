#= require ../auto_complete/search_view

class window.AutoCompleteUsersView extends AutoCompleteSearchView
  className: "auto-complete auto-complete-users"

  events:
    "click div.auto-complete-search-list": "addCurrent"

  regions:
    'results': 'div.auto-complete-results-container'
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.auto-complete-input-container'

  template: "auto_complete/box_with_results"

  initialize: ->
    @initializeChildViews
      filter_on: 'username'
      results_view: AutoCompleteResultsUsersView
      search_collection: UserSearchResults
      search_list_view: AutoCompleteSearchUsersView

  addCurrent: ->
    user = @_search_list_view.currentActiveModel()
    @collection.add user
    @model.set text: ''
