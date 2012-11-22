class window.AutoCompleteSearchView extends Backbone.Marionette.Layout
  initializeChildViews: (opts)->
    @search_collection = opts.search_collection()

    @initSearchModel()
    @initTextInputView opts.placeholder
    @initFilteredSearchCollection opts.search_collection, opts.filter_on
    @initSearchListView opts.search_list_view

    @bindTextViewToSteppableViewAndSelf(@_text_input_view, @_search_list_view)

    @on('render', @renderChildViews)

  initSearchModel: ->
    @model = new Backbone.Model text: ''
    @model.on 'change', => @search_collection.searchFor @model.get('text')

  initTextInputView: (placeholder) ->
    @_text_input_view = new Backbone.Factlink.TextInputView
      model: @model
      placeholder: placeholder ? ''

  initFilteredSearchCollection: (search_collection, filter_on) ->
    if search_collection? and filter_on?
      @filtered_search_collection = collectionDifference(search_collection(),
        filter_on, @search_collection, @collection)
    else
      @filtered_search_collection = @search_collection

  initSearchListView: (search_list_view) ->
    @_search_list_view = search_list_view
      model: @model
      collection: @filtered_search_collection

  bindTextViewToSteppableViewAndSelf: (text_view, steppable_view)->
    @bindTo text_view, 'down', -> steppable_view.moveSelectionDown()
    @bindTo text_view, 'up',   -> steppable_view.moveSelectionUp()
    @bindTo text_view, 'return', @addCurrent, this

  renderChildViews: ->
    @results.show @_results_view if @_results_view
    @search_list.show @_search_list_view
    @text_input.show @_text_input_view

  addCurrent: ->
    console.error "the function to add current selection was not implemented"

  initialEvents: -> # Remove this line when updating Marionette
    # In our version of Marionette a Layout re-renders when its @collection gets a 'reset' event
