class window.Discussion extends Backbone.Model
  initialize: (opts) ->
    @_fact = opts.fact
    @_relations = opts.relations
    @_type = opts.type

  relations: -> @_relations ?= @getFactRelations()
  fact: -> @_fact
  type: -> @_type

  comments: -> @_comments ?= @getComments()

  getComments: ->
    # TODO: this should be dynamicz
    comment1 = new Comment id: 1, content: "Hoi doei Henk"
    comment2 = new Comment id: 2, content: "Richie Hawtin - Live @ Amsterdam Dance Event"

    new Backbone.Collection [comment1, comment2]

  getFactRelations: ->
    switch @type()
      when 'supporting'
        new SupportingFactRelations([],fact: @fact())
      when 'weakening'
        new WeakeningFactRelations([],fact: @fact())
      else `undefined`

  getInteractors: ->
    collectionType = switch @type()
      when 'supporting' then FactBelieversPage
      when 'weakening' then FactDisbelieversPage
      when 'doubting' then FactDoubtersPage
    new collectionType fact: @fact()
