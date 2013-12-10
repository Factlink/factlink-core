class window.EvidenceCollection extends Backbone.Factlink.Collection

  initialize: (models, options) ->
    @fact = options.fact

    @realEvidenceCollection = new RealEvidenceCollection null, fact: @fact, type: 'supporting'

    @_containedCollections = [
      new OpinionatersCollection null, fact: @fact
      @realEvidenceCollection
    ]

    for collection in @_containedCollections
      @listenTo collection, 'sync', @loadFromCollections
      @listenTo collection, 'add', (model) -> @add model
      @listenTo collection, 'remove', (model) -> @remove model
      @listenTo collection, 'start_adding_model', -> @trigger 'start_adding_model'
      @listenTo collection, 'saved_added_model', -> @trigger 'saved_added_model'
      @listenTo collection, 'error_adding_model', -> @trigger 'error_adding_model'

  comparator: (item) -> -item.get('impact')

  fetch: (options={}) ->
    @trigger 'request', @
    _.invoke @_containedCollections, 'fetch', _.extend {}, options, reset: true

  _sub_loading: ->
    _.some @_containedCollections, (collection) -> collection.loading()

  loadFromCollections: (collectionOrModel) ->
    return if @_sub_loading() || !@loading()

    @reset(_.union (col.models for col in @_containedCollections)...)
    @trigger 'sync', @
