class window.AutoCompleteSearchView extends Backbone.Marionette.Layout
  initializeChildViews: (opts)->
    [@model, @search_collection] = @searchCollection(opts.search_collection)

    @_text_input_view = new Backbone.Factlink.TextInputView model: @model

    if opts.results_view
      @_results_view = new opts.results_view(collection: @collection)

    if opts.filter_on
      @filtered_search_collection = collectionDifference(opts.search_collection,
        opts.filter_on, @search_collection, @collection)
    else 
      @filtered_search_collection = @search_collection

    @_search_list_view = new opts.search_list_view
      model: @model
      collection: @filtered_search_collection

    @bindTextViewToSteppableViewAndSelf(@_text_input_view, @_search_list_view)

    @on('render', @renderChildViews)

  searchCollection: (type)->
    model = new Backbone.Model text: ''
    collection = new type()
    model.on 'change', -> collection.searchFor model.get('text')

    [model, collection]

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
