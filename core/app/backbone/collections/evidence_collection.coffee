class window.EvidenceCollection extends Backbone.Collection
  comparator: (evidence) ->
    # TODO: breaks with relevance > 1000
    -parseFloat(evidence.get('opinions')?.formatted_relevance || '0.0');
