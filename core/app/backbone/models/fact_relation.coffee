class window.FactRelation extends Evidence

  defaults:
    evidence_type: 'FactRelation'
    sub_comments_count: 0

  argumentTally: ->
    @_argumentTally ?= new ArgumentTally @get('tally'),
      argument: this

  getFact: ->
    return @_fact if @_fact?

    @_fact = new Fact(@get('from_fact'))
    @on 'change:from_fact', =>
      @_fact.set @get('from_fact')
    @_fact

  creator: -> new User(@get('created_by'))

  _is_mine: -> @creator().is_current_user()

  can_destroy: -> @_is_mine() && @get('is_deletable')

  urlRoot: -> @collection.factRelationsUrl()

  validate: (attributes) ->
    unless attributes.evidence_id? or /^.*\S.*$/.test(attributes.displaystring)
      'Should have either an evidence_id or a displaystring'
