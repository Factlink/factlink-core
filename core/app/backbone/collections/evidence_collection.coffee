class window.EvidenceCollection extends Backbone.Collection
  comparator: (evidence) ->
    # TODO: breaks with relevance > 1000
    -parseFloat(evidence.get('opinions')?.formatted_relevance || '0.0');

  model: (attrs, options) ->
    switch attrs.evidence_type
      when 'FactRelation'
        new FactRelation attrs, options
      when 'Comment'
        new Comment attrs, options
      else `undefined`

  initialize: (models, opts) ->
    @type = opts.type
    @fact = opts.fact

  url: -> "/facts/#{@fact.id}/#{@type}_evidence/combined"
