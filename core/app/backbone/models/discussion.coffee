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
    comment1 = new Comment id: 1, "can_destroy?": true, content: "I think of boredom as a clock. Every second that someone on my team is bored, a second passes on this clock. After some aggregated amount of seconds that varies for every person, they look at the time, throw up their arms, and quit."
    comment2 = new Comment id: 2, content: "Richie Hawtin - Live @ Amsterdam Dance Event"

    new Comments [comment1, comment2]

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
