class window.EvidenceCollection extends Backbone.Factlink.Collection

  initialize: (models, options) ->
    @fact = options.fact

  parse: (data) ->
    _.map data, (item) ->
      switch item.evidence_type
        when 'FactRelation'
          new FactRelation(item)
        when 'Comment'
          new Comment(item)
        else
          console.error "Evidence type not supported: #{item.evidence_type}"

  url: -> "/facts/#{@fact.id}/evidence"

  commentsUrl: -> "#{@fact.url()}/comments"
  factRelationsUrl: -> @url()
