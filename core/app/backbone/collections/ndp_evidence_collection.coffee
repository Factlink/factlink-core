class window.NDPEvidenceCollection extends Backbone.Factlink.Collection

  initialize: (models, options) ->
    @on 'change sync', @sort, @
    @fact = options.fact

    @_opinionatersCollection = new OpinionatersCollection null, fact: @fact
    @_supportingCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'supporting'
    @_weakeningCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'weakening'

    collectionUtils = new CollectionUtils
    collectionUtils.union this, @_opinionatersCollection, @_supportingCollection, @_weakeningCollection

  comparator: (item) -> - item.get('impact')

  loading: ->
    @_opinionatersCollection.loading() ||
      @_supportingCollection.loading() ||
      @_weakeningCollection.loading()

  fetch: (options={}) ->
    @trigger 'before:fetch'
    @_opinionatersCollection.fetch options
    @_supportingCollection.fetch options
    @_weakeningCollection.fetch options
