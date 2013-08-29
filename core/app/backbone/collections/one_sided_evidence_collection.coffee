class window.OneSidedEvidenceCollection extends Backbone.Factlink.Collection

  initialize: (models, opts) ->
    @type = opts.type
    @fact = opts.fact

  parse: (data) ->
    _.map data, (item) ->
      switch item.evidence_type
        when 'FactRelation'
          new FactRelation(item)
        when 'Comment'
          new Comment(item)
        else
          console.error "Evidence type not supported: #{item.evidence_type}"

  url:     -> "#{@baseUrl()}/combined"
  baseUrl: -> "/facts/#{@fact.id}/#{@type}_evidence"

  commentsUrl: -> "#{@fact.url()}/comments/#{@type}"
  factRelationsUrl: -> @baseUrl()

  # TODO: Kill those different names for things... :-(
  believesType: ->
    switch @type
      when 'supporting' then 'believes'
      when 'weakening' then 'disbelieves'
      else throw 'Unknown OneSidedEvidenceCollection type'
