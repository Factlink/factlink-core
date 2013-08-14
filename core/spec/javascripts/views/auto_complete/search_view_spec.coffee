#= require sinon-chai
#= require sinon
#= require application
#= require frontend

describe 'AutoCompleteSearchView', ->
  describe 'initializeChildViews', ->
    it 'should initialize a text input view and search list view', ->
      view = new AutoCompleteSearchView
        collection: new Backbone.Collection

      text_input_view = new Backbone.Marionette.ItemView
      auto_complete_search_list_view = new Backbone.Marionette.CollectionView

      window.AutoCompleteSearchListView = sinon.stub().returns(auto_complete_search_list_view)
      Backbone.Factlink.TextInputView = sinon.stub().returns(text_input_view)

      view.initializeChildViews(
        search_collection: new SearchCollection
        filtered_search_collection: new SearchCollection
        search_list_view: (options) -> new AutoCompleteSearchListView(options)
        placeholder: 'placeholder'
        filter_on: 'bla'
      )

      expect(Backbone.Factlink.TextInputView).to.have.been.calledWith(
        model: view.model
        placeholder: 'placeholder'
      )
      expect(window.AutoCompleteSearchListView).to.have.been.calledWith(
        model: view.model
        collection: view.filtered_search_collection
      )

    it 'should create a collectionDifference', ->
      collection = new Backbone.Collection
      view = new AutoCompleteSearchView
        collection: collection

      view.initializeChildViews(
        search_collection: new SearchCollection
        filtered_search_collection: new SearchCollection
        search_list_view: (options) -> new AutoCompleteSearchListView(options)
        placeholder: 'placeholder'
        filter_on: 'bla'
      )

      expect(view.filtered_search_collection).to.have.length(0)

      # after two results are found:
      view.search_collection.reset [new Backbone.Model(bla: 1), new Backbone.Model(bla: 2)]
      expect(view.filtered_search_collection).to.have.length(2)

      # after one is added to the list (on which is filtered)
      collection.add new Backbone.Model(bla: 1)
      expect(view.filtered_search_collection).to.have.length(1)

  describe 'searchCollection', ->
    it 'should return a linked model', ->
      view = new AutoCompleteSearchView


      spied_search_collection = SearchCollection
      spied_search_collection.searchFor = sinon.stub()

      view.search_collection = spied_search_collection

      model = view.initSearchModel()

      model.set('text', 'test')

      expect(view.search_collection.searchFor).to.have.been.calledWith('test')
