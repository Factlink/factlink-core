class window.EvidenceCollection extends Backbone.Factlink.Collection

  initialize: (models, options) ->
    @fact = options.fact

    @realEvidenceCollection = new RealEvidenceCollection null, fact: @fact

    @_containedCollections = [
      new OpinionatersCollection null, fact: @fact
      @realEvidenceCollection
    ]

    for collection in @_containedCollections
      @listenTo collection, 'sync', @loadFromCollections
      @listenTo collection, 'add', (model) -> @add model
      @listenTo collection, 'remove', (model) -> @remove model

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
