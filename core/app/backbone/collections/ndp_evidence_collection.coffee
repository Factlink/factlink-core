class OpinionatorsCollection extends Backbone.Factlink.Collection
  model: OpinionatersEvidence

  default_fetch_data:
    take: 7

  initialize: (models, options) ->
    @fact = options.fact

    @_wheel = @fact.getFactWheel()
    @_wheel.on 'sync', =>
      @fetch()

  url: ->
    "/facts/#{@fact.id}/interactors"

  fetch: (options={}) ->
    options.data = _.extend {}, @default_fetch_data, options.data || {}
    super options


class window.NDPEvidenceCollection extends Backbone.Collection

  initialize: (models, options) ->
    @on 'change sync', @sort, @
    @fact = options.fact

    @_opinionatorsCollection = new OpinionatorsCollection null, fact: @fact
    @_supportingCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'supporting'
    @_weakeningCollection = new OneSidedEvidenceCollection null, fact: @fact, type: 'weakening'

    collectionUtils = new CollectionUtils
    collectionUtils.union this, @_opinionatorsCollection, @_supportingCollection, @_weakeningCollection

    @loading = false

  comparator: (item) -> - item.get('impact')

  fetch: (options={}) ->
    @loading = true
    success = options.success

    options.success = =>
      @loading = false
      success? arguments...
      @trigger 'sync'

    @_opinionatorsCollection.fetch options
    @_supportingCollection.fetch options
    @_weakeningCollection.fetch options
