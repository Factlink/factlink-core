class AutoCompleteSearchFactView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "facts/auto_complete_search_fact"

  templateHelpers: ->
    query = @options.query

    highlighted_title: -> highlightTextInTextAsHtml(query, @displaystring)

  scrollIntoView: -> scrollIntoViewWithinContainer @$el, @$el.parents('.auto-complete-search-list')

class AutoCompleteSearchFactsView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchFactView

  template: "facts/auto_complete_search_facts"

  ui:
    recent_list: '.js-list-recent'
    search_list: '.js-list-search'

    recent_row: '.js-row-recent'
    search_row: '.js-row-search'

  onRender: -> @updateRows()

  appendHtml: (collectionView, itemView, index) ->
    model = itemView.model
    if @options.recent_collection.get(model.id)?
      @ui.recent_list.append itemView.el
    else
      @ui.search_list.append itemView.el

    @updateRows()

  updateRows: ->
    @_updateRowActive @ui.recent_row, @ui.recent_list
    @_updateRowActive @ui.search_row, @ui.search_list

  _updateRowActive: ($row, $list) ->
    $row.toggleClass 'auto-complete-search-list-active', $list.find('li').length > 0

class window.AutoCompleteFactsView extends AutoCompleteSearchView
  className: "auto-complete"

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.js-auto-complete-input-view-container'

  template: 'facts/auto_complete_facts'

  initialize: ->
    @_recent_collection = new RecentlyViewedFacts
    @_recent_collection.fetch()

    @initializeChildViews
      filter_on: 'id'
      search_list_view: (options) => new AutoCompleteSearchFactsView _.extend {}, options,
        recent_collection: @_recent_collection
      search_collection: new FactSearchResults [],
        fact_id: @options.fact_id
        recent_collection: @_recent_collection
      filtered_search_collection: new FilteredFactSearchResults
      placeholder: 'Search discussion link to insert...'

    @listenTo @model, 'change', @queryChanges

  onRender: ->
    @_text_input_view.focusInput()

  addCurrent: ->
    selected_fact = @_search_list_view.currentActiveModel()
    return unless selected_fact?

    @trigger 'insert', selected_fact.friendly_fact_url()

  reset: ->
    @model.set text: ''

  queryChanges: ->
    unless @query_has_changed
      @query_has_changed = true
      mp_track "Evidence: Started searching for insertable discussion"
