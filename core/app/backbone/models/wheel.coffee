class window.Wheel extends Backbone.Model
  defaults:
    opinion_types: {}
    authority: '0.0'

  default_opinion_types:
    believe:
      type: 'believe'
      is_user_opinion: false
      percentage: 33
    doubt:
      type: 'doubt'
      is_user_opinion: false
      percentage: 33
    disbelieve:
      type: 'disbelieve'
      is_user_opinion: false
      percentage: 33

  initialize: ->
    @set 'opinion_types', @mergedOpinionTypes()

  setRecursive: (newAttributes, oldAttributes=@attributes) ->
    for key, value of newAttributes
      if typeof value is 'object'
        oldAttributes[key] ?= {}
        @setRecursive value, oldAttributes[key]
      else
        oldAttributes[key] = value

  mergedOpinionTypes: ->
    opinion_types = {}
    for type, opinion_type of @default_opinion_types
      opinion_types[type] = _.defaults(@get('opinion_types')[type] ? {}, opinion_type)
    opinion_types

  opinionTypesArray: -> _.values @get('opinion_types')

  clear: (options)->
    super _.extend {}, options, silent: true
    @set(new Wheel().attributes)

  isUserOpinion: (type) -> @get('opinion_types')[type].is_user_opinion

  userOpinion: ->
    @_userOpinions()[0]

  _userOpinions: ->
    "#{type}s" for type, opinionType of @get('opinion_types') when opinionType.is_user_opinion

  updateTo: (authority, opinionTypes) ->
    new_opinion_types = {}
    for type, oldOpinionType of @get('opinion_types')
      new_opinion_types[type] = _.extend _.clone(oldOpinionType), opinionTypes[type]

    @set
      authority: authority
      opinion_types: new_opinion_types

  toJSON: ->
    _.extend {}, super(),
      opinion_types_array: @opinionTypesArray()
