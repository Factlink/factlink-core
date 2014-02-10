ReactAutoCompleteSearchFactView = React.createBackboneClass
  displayName: 'ReactAutoCompleteSearchFactView'

  scrollIntoView: ->
    $el = $(@getDOMNode())
    scrollIntoViewWithinContainer $el, $el.parents('.auto-complete-search-list')

  render: ->
    displaystring = @model().get('displaystring')

    _div
      className: 'auto-complete-search-list-item' + (if @props.selected then ' selected' else '')
      title: displaystring
      onMouseEnter: @props.onMouseEnter
      onMouseLeave: @props.onMouseLeave
      onClick: @props.onClick
      dangerouslySetInnerHTML:
        {__html: highlightTextInTextAsHtml(@props.query, displaystring)}

ReactAutoCompleteSearchFactsView = React.createBackboneClass
  displayName: 'ReactAutoCompleteSearchFactsView'

  getInitialState: ->
    selectedModelKey: null

  _childView: (fact, key) ->
    new ReactAutoCompleteSearchFactView
      model: fact
      query: @model().query
      selected: key == @state.selectedModelKey
      ref: key
      onMouseEnter: => @setState selectedModelKey: key
      onMouseLeave: => @setState selectedModelKey: null
      onClick: => @setState selectedModelKey: key; @props.onSelect?()

  selectedModel: ->
    return unless @state.selectedModelKey?

    @model().at(@state.selectedModelKey)

  componentDidMount: (el) ->
    $(el).preventScrollPropagation()

  render: ->
    return _div() unless @model().length > 0

    _div ['auto-complete-search-list'],
      @model().map (fact, key) =>
        @_childView(fact, key)

  _fixKeyModulo: (key)->
    if key >= @model().length then 0
    else if key < 0 then @model().length - 1
    else key

  _select: (key) ->
    key = @_fixKeyModulo(key)
    @setState selectedModelKey: key
    @refs[key].scrollIntoView()

  moveSelectionUp: ->
    @_select if @state.selectedModelKey? then @state.selectedModelKey-1 else -1

  moveSelectionDown: ->
    @_select if @state.selectedModelKey? then @state.selectedModelKey+1 else 0

class window.AutoCompleteFactsView extends Backbone.Marionette.Layout
  className: "auto-complete"

  regions:
    'search_list': 'div.auto-complete-search-list-container'
    'text_input': 'div.js-auto-complete-input-view-container'

  template: 'facts/auto_complete_facts'

  initialize: ->
    @search_collection = new FactSearchResults [], fact_id: @options.fact_id
    @listenTo @search_collection, 'request', -> @$el.addClass 'auto-complete-loading'
    @listenTo @search_collection, 'sync', -> @$el.removeClass 'auto-complete-loading'

    @_search_list_view = new ReactAutoCompleteSearchFactsView
      model: @search_collection
      onSelect: => @addSelectedModel()

    @_text_input_view = new Backbone.Factlink.ReactTextInputView
      placeholder: 'Search discussion link to insert...'
      onChange: (value) =>
        @search_collection.searchFor value
        @queryChanges()
      onUp: => @_search_list_view.moveSelectionUp()
      onDown: => @_search_list_view.moveSelectionDown()
      onReturn: => @addSelectedModel()

  onRender: ->
    @search_list.show new ReactView component: @_search_list_view
    @text_input.show new ReactView component: @_text_input_view
    @_text_input_view.focusInput()

  addSelectedModel: ->
    selected_fact = @_search_list_view.selectedModel()
    return unless selected_fact?

    @trigger 'insert', selected_fact.friendly_fact_url()

  queryChanges: ->
    unless @query_has_changed
      @query_has_changed = true
      mp_track "Evidence: Started searching for insertable discussion"
