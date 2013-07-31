class window.NDPEvidenceCollection extends Backbone.Collection

  initialize: (models, options) ->
    @on 'change sync', @sort, @
    @fact = options.fact

    @_opinionatersCollection = new OpinionatersCollection null, fact: @fact
    @_supportingCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'supporting'
    @_weakeningCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'weakening'

    collectionUtils = new CollectionUtils
    collectionUtils.union this, @_opinionatersCollection, @_supportingCollection, @_weakeningCollection

    @loading = false

  comparator: (item) -> - item.get('impact')

  fetch: (options={}) ->
    @loading = true
    success = options.success

    options.success = =>
      @loading = false
      success? arguments...
      @trigger 'sync'

    @_opinionatersCollection.fetch options
    @_supportingCollection.fetch options
    @_weakeningCollection.fetch options
