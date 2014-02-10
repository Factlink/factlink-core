ReactFactSearchResult = React.createBackboneClass
  displayName: 'ReactFactSearchResult'

  scrollIntoView: ->
    $el = $(@getDOMNode())
    scrollIntoViewWithinContainer $el, $el.parents('.fact-search-results')

  render: ->
    displaystring = @model().get('displaystring')

    _div [
      'fact-search-result'
      'fact-search-result-selected' if @props.selected
      title: displaystring
      onMouseEnter: @props.onMouseEnter
      onMouseLeave: @props.onMouseLeave
      onClick: @props.onClick
      dangerouslySetInnerHTML:
        {__html: highlightTextInTextAsHtml(@props.query, displaystring)}
    ]

ReactFactSearchResults = React.createBackboneClass
  displayName: 'ReactFactSearchResults'
  changeOptions: 'add remove reset sort sync'

  getInitialState: ->
    selectedModelIndex: null

  _childView: (fact, index) ->
    ReactFactSearchResult
      model: fact
      query: @model().query
      selected: index == @state.selectedModelIndex
      ref: index
      key: fact.id
      onMouseEnter: => @setState selectedModelIndex: index
      onMouseLeave: => @setState selectedModelIndex: null
      onClick: => @setState selectedModelIndex: index; @props.onSelect?()

  selectedModel: ->
    return unless @state.selectedModelIndex?

    @model().at(@state.selectedModelIndex)

  componentDidMount: (el) ->
    $(el).preventScrollPropagation()

  render: ->
    return _div() unless @model().length > 0

    _div ['fact-search-results'],
      @model().map (fact, index) =>
        @_childView(fact, index)

  _fixIndexModulo: (index)->
    if index >= @model().length then 0
    else if index < 0 then @model().length - 1
    else index

  _select: (index) ->
    index = @_fixIndexModulo(index)
    @setState selectedModelIndex: index
    @refs[index].scrollIntoView()

  moveSelectionUp: ->
    @_select if @state.selectedModelIndex? then @state.selectedModelIndex-1 else -1

  moveSelectionDown: ->
    @_select if @state.selectedModelIndex? then @state.selectedModelIndex+1 else 0

window.ReactFactSearch = React.createBackboneClass
  displayName: 'ReactFactSearch'
  changeOptions: 'request sync'

  _loadingIndicator: ->
    return unless @model().loading()

    _img ['fact-search-loading-indicator', src: Factlink.Global.ajax_loader_image]

  render: ->
    _div [],
      _div ['fact-search-input-container'],
        Backbone.Factlink.ReactTextInputView
          ref: 'text'
          placeholder: 'Search discussion link to insert...'
          onChange: (value) =>
            @model().searchFor value
            @_queryChanges()
          onUp: => @refs.search.moveSelectionUp()
          onDown: => @refs.search.moveSelectionDown()
          onReturn: => @addSelectedModel()
        @_loadingIndicator()
      ReactFactSearchResults
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
