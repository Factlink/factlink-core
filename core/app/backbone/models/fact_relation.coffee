class window.FactRelation extends Evidence

  defaults:
    evidence_type: 'FactRelation'
    sub_comments_count: 0

  argumentVotes: ->
    @_argumentVotes ?= new ArgumentVotes @get('argument_votes'),
      urlRoot: @url()

  getFact: ->
    return @_fact if @_fact?

    @_fact = new Fact(@get('from_fact'))
    @on 'change:from_fact', =>
      @_fact.set @get('from_fact')
    @_fact

  creator: -> new User(@get('created_by'))

  can_destroy: -> @get 'can_destroy?'

  urlRoot: -> @collection.factRelationsUrl()

  validate: (attributes) ->
    unless attributes.evidence_id? or /^.*\S.*$/.test(attributes.displaystring)
      'Should have either an evidence_id or a displaystring'
