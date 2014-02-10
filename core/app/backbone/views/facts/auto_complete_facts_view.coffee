class AutoCompleteSearchFactView extends Backbone.Marionette.CompositeView
  tagName: "li"

  template: "facts/auto_complete_search_fact"

  triggers:
    "mouseenter": "requestActivate",
    "mouseleave": "requestDeActivate",
    "click"     : "requestClick"

  templateHelpers: ->
    query = @options.query

    highlighted_title: -> highlightTextInTextAsHtml(query, @displaystring)

  initialize: ->
    @on 'activate', => @$el.addClass 'active'
    @on 'deactivate', => @$el.removeClass 'active'

  scrollIntoView: -> scrollIntoViewWithinContainer @$el, @$el.parents('.auto-complete-search-list')

class AutoCompleteSearchFactsView extends Backbone.Marionette.CompositeView
  itemViewContainer: 'ul'
  itemView: AutoCompleteSearchFactView
  itemViewOptions: => query: '' # @model.get('text')

  className: 'auto-complete-search-list'
  template: "facts/auto_complete_search_facts"

  ui:
    recent_list: '.js-list-recent'
    search_list: '.js-list-search'

    recent_row: '.js-row-recent'
    search_row: '.js-row-search'

  initialize: ->
    @on 'after:item:added', @onItemAddedDoSteppableInitialization, this
    @on 'composite:collection:rendered', => @setActiveView 0
    @on 'item:removed', @removeViewFromList

    @list = []

    @on 'render', -> @$el.preventScrollPropagation()

  showEmptyView: -> @$el.hide()
  closeEmptyView: -> @$el.show()

  onClose: ->
    @list = []

  deActivateCurrent: ->
    @currentActiveView()?.trigger('deactivate');
    @activeViewKey = `undefined`

  fixKeyModulo: (key)->
    if key >= @list.length then 0
    else if key < 0 then @list.length - 1
    else key

  setActiveView: (key)->
    @deActivateCurrent()
    key = @fixKeyModulo(key)
    view = @list[key]
    if view
      view.trigger('activate');
      @activeViewKey = key

  moveSelectionUp: ->
    prevKey = if @activeViewKey? then @activeViewKey - 1 else -1
    @setActiveView prevKey
    @scrollToCurrent()

  moveSelectionDown: ->
    nextKey = if @activeViewKey? then @activeViewKey + 1 else 0
    @setActiveView nextKey
    @scrollToCurrent()

  removeViewFromList: (view) ->
    i = @list.indexOf(view)
    @list.splice(i,1)

  onItemAddedDoSteppableInitialization: (view) ->
    @listenTo view, 'requestActivate', -> @requestActivate view

    @listenTo view, 'requestDeActivate', -> @deActivateCurrent()

    @listenTo view, 'requestClick', ->
      @requestActivate view
      @trigger 'click'

    @list.push(view)

  currentActiveModel: -> @currentActiveView()?.model

  currentActiveView: ->
    if 0 <= @activeViewKey < @list.length
      @list[@activeViewKey]
    else
     null

  scrollToCurrent: ->
    @currentActiveView()?.scrollIntoView?()

  requestActivate: (view) ->
    unless @alreadyHandlingAnActivate
      @alreadyHandlingAnActivate = true
      i = @list.indexOf(view)
      @setActiveView(i)
      @alreadyHandlingAnActivate = false

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
      search_list_view: (options) => new AutoCompleteSearchFactsView _.extend {}, options,
        recent_collection: @_recent_collection
      search_collection: new FactSearchResults [],
        fact_id: @options.fact_id
        recent_collection: @_recent_collection
      placeholder: 'Search discussion link to insert...'

    # @listenTo @model, 'change', @queryChanges

  onRender: ->
    @_text_input_view.focusInput()

  addCurrent: ->
    selected_fact = @_search_list_view.currentActiveModel()
    return unless selected_fact?

    @trigger 'insert', selected_fact.friendly_fact_url()

  reset: ->
    # @model.set text: ''

  # queryChanges: ->
  #   unless @query_has_changed
  #     @query_has_changed = true
  #     mp_track "Evidence: Started searching for insertable discussion"
