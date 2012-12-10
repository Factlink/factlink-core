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
        search_collection: -> new SearchCollection
        search_list_view: (options) -> new AutoCompleteSearchListView(options)
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
      spyOn(view, 'bindTextViewToSteppableViewAndSelf')

      view.initializeChildViews(
        search_collection: -> new SearchCollection
        search_list_view: (options) -> new AutoCompleteSearchListView(options)
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

  describe 'searchCollection', ->
    it 'should return a linked model', ->
      view = new AutoCompleteSearchView
      view.search_collection = new SearchCollection
      model = view.initSearchModel()
      spyOn(view.search_collection, 'searchFor')

      model.set('text', 'test')

      expect(view.search_collection.searchFor).toHaveBeenCalledWith('test')
