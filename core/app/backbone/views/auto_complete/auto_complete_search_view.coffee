class window.AutoCompleteSearchView extends Backbone.Marionette.Layout
  initializeChildViews: (opts)->
    @initSearchCollection(opts.search_collection)

    @initSearchModel()
    @initTextInputView opts.placeholder
    @initFilteredSearchCollection opts.filtered_search_collection, opts.filter_on
    @initSearchListView opts.search_list_view

    @bindTextViewToSteppableViewAndSelf(@_text_input_view, @_search_list_view)

    @on('render', @renderChildViews)

  initSearchModel: ->
    @model = new Backbone.Model text: ''
    @model.on 'change', => @search_collection.searchFor @model.get('text')

  initSearchCollection: (collection) ->
    @search_collection = collection
    @listenTo @search_collection, 'request', @setLoading
    @listenTo @search_collection, 'sync', @unsetLoading

  initTextInputView: (placeholder) ->
    @_text_input_view = new Backbone.Factlink.TextInputView
      model: @model
      placeholder: placeholder ? ''

  initFilteredSearchCollection: (filtered_search_collection, filter_on) ->
    if filtered_search_collection? and filter_on?
      @filtered_search_collection = collectionDifference(filtered_search_collection,
        filter_on, @search_collection, @collection)
    else
      @filtered_search_collection = @search_collection

  initSearchListView: (search_list_view) ->
    @_search_list_view = search_list_view
      model: @model
      collection: @filtered_search_collection

  setLoading: ->
    @$el.addClass 'auto-complete-loading'

  unsetLoading: ->
    @$el.removeClass 'auto-complete-loading'

  bindTextViewToSteppableViewAndSelf: (text_view, steppable_view)->
    @listenTo text_view, 'down', -> steppable_view.moveSelectionDown()
    @listenTo text_view, 'up',   -> steppable_view.moveSelectionUp()
    @listenTo text_view, 'return', @addCurrent
    @listenTo steppable_view, 'click', @addCurrent

  renderChildViews: ->
    @results.show @_results_view if @_results_view
    @search_list.show @_search_list_view
    @text_input.show @_text_input_view

  clearSearch: ->
    @model.set 'text', ''

  addCurrent: ->
    console.error "the function to add current selection was not implemented"
