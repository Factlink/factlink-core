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
    ReactAutoCompleteSearchFactView
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

window.ReactAutoCompleteFactsView = React.createBackboneClass
  displayName: 'ReactAutoCompleteFactsView'
  changeOptions: 'add remove reset sort request sync'

  _loadingIndicator: ->
    return unless @model().loading()

    _img ['auto-complete-loading-indicator', src: Factlink.Global.ajax_loader_image]

  render: ->
    _div [],
      _div ['auto-complete-input-container'],
        Backbone.Factlink.ReactTextInputView
          ref: 'text'
          placeholder: 'Search discussion link to insert...'
          onChange: (value) =>
            @model().searchFor value
            @_queryChanges()
          onUp: => @_search_list_view.moveSelectionUp()
          onDown: => @_search_list_view.moveSelectionDown()
          onReturn: => @addSelectedModel()
        @_loadingIndicator()
      ReactAutoCompleteSearchFactsView
        ref: 'search'
        model: @model()
        onSelect: => @addSelectedModel()

  focus: ->
    @refs.text.focusInput()

  addSelectedModel: ->
    selected_fact = @refs.search.selectedModel()
    return unless selected_fact?

    @props.onInsert?(selected_fact.friendly_fact_url())

  _queryChanges: ->
    unless @query_has_changed
      @query_has_changed = true
      mp_track "Evidence: Started searching for insertable discussion"
