class window.AutoCompleteSearchView extends Backbone.Marionette.Layout
  initialize_child_views: (opts)->
    @_results_view = new opts.result_view
      collection: @collection

    [@model, @search_collection] = @searchCollection(opts.search_collection)

    @_text_input_view = new TextInputView model: @model

    @filtered_search_collection = collectionDifference(opts.search_collection,
      opts.filter_on, @search_collection, @collection)

    @_auto_completes_view = new opts.auto_completes_view
      model: @model
      collection: @filtered_search_collection

    @bindTextViewToSteppableViewAndSelf(@_text_input_view, @_auto_completes_view)

  searchCollection: (type)->
    model = new Backbone.Model text: ''
    collection = new type()
    model.on 'change', -> collection.searchFor model.get('text')

    [model, collection]

  bindTextViewToSteppableViewAndSelf: (text_view, steppable_view)->
    @bindTo text_view, 'down', -> steppable_view.moveSelectionDown()
    @bindTo text_view, 'up',    -> steppable_view.moveSelectionUp()
    @bindTo text_view, 'return', @addCurrent, this

  addCurrent: ->
    console.error "the function to add current selection was not implemented"
