describe 'AutoCompleteSearchView', ->
  describe 'initializeChildViews', ->
    it 'should initialize a text input view and search list view', ->
      view = new AutoCompleteSearchView
      text_input_view = {}
      auto_complete_search_list_view = {}

      spyOn(window, 'AutoCompleteSearchListView').andReturn(auto_complete_search_list_view)
      spyOn(Backbone.Factlink, 'TextInputView').andReturn(text_input_view)
      spyOn(view, 'bindTextViewToSteppableViewAndSelf')

      view.initializeChildViews(
        search_collection: SearchCollection
        search_list_view: AutoCompleteSearchListView
        placeholder: 'placeholder'
      )

      expect(Backbone.Factlink.TextInputView).toHaveBeenCalledWith(
        model: view.model
        placeholder: 'placeholder'
      )
      expect(window.AutoCompleteSearchListView).toHaveBeenCalledWith(
        model: view.model
        collection: view.search_collection
      )
      expect(view.bindTextViewToSteppableViewAndSelf).toHaveBeenCalledWith(text_input_view, auto_complete_search_list_view)

    it 'should create a collectionDifference if filter_on and @collection are given', ->
      collection = new Backbone.Collection []
      view = new AutoCompleteSearchView
        collection: collection

      spyOn(window, 'AutoCompleteSearchListView').andReturn({})

      view.initializeChildViews(
        search_collection: SearchCollection
        search_list_view: AutoCompleteSearchListView
        placeholder: 'placeholder'
        filter_on: 'bla'
      )

      expect(view.filtered_search_collection.length).toEqual(0)

      spyOn(view.search_collection, 'searchFor').andCallFake ->
        view.search_collection.reset [new Backbone.Model(bla: 1), new Backbone.Model(bla: 2)]

      view.model.set('text', 'hoi')
      expect(view.filtered_search_collection.length).toEqual(2)

      collection.add new Backbone.Model(bla: 1)
      expect(view.filtered_search_collection.length).toEqual(1)

    it 'should create a results view if results_view is given', ->
      collection = {}
      view = new AutoCompleteSearchView
        collection: collection

      ResultsView = jasmine.createSpy('ResultsView')

      view.initializeChildViews(
        search_collection: SearchCollection
        search_list_view: AutoCompleteSearchListView
        placeholder: 'placeholder'
        results_view: ResultsView
      )

      expect(ResultsView).toHaveBeenCalledWith(collection: collection)

  describe 'searchCollection', ->
    it 'should return a linked model and collection', ->
      view = new AutoCompleteSearchView
      [model, collection] = view.searchCollection(SearchCollection)
      spyOn(collection, 'searchFor')

      model.set('text', 'test')

      expect(collection.searchFor).toHaveBeenCalledWith('test')
