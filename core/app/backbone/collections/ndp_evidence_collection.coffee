class window.NDPEvidenceCollection extends Backbone.Factlink.Collection

  initialize: (models, options) ->
    @fact = options.fact

    @_supportingCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'supporting'
    @_weakeningCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'weakening'

    @_containedCollections = [
      new OpinionatersCollection null, fact: @fact
      @_supportingCollection
      @_weakeningCollection
    ]

    for collection in @_containedCollections
      @listenTo collection, 'sync', @onCollectionSync
      @listenTo collection, 'add', @loadFromCollections

  comparator: (item) -> - item.get('impact')

  loading: ->
    _.some @_containedCollections, (collection) -> collection.loading()

  fetch: (options={}) ->
    @trigger 'request', this
    _.invoke @_containedCollections, 'fetch', _.extend {}, options, reset: true

  onCollectionSync: (collectionOrModel) ->
    return unless collectionOrModel in @_containedCollections # collection proxies model's sync
    @loadFromCollections()

  loadFromCollections: ->
    return if @loading()

    @reset(_.union (col.models for col in @_containedCollections)...)
    @trigger 'sync'

  oneSidedEvidenceCollection: (type) ->
    switch type
      when 'supporting' then @_supportingCollection
      when 'weakening' then @_weakeningCollection
      else throw 'Unknown OneSidedEvidenceCollection type'
