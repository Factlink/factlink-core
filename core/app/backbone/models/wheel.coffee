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

  setRecursive: (attributes) ->
    @_updateAttributes @attributes, attributes

  _updateAttributes: (oldAttributes, newAttributes) ->
    for key, value of newAttributes
      if typeof value is 'object'
        oldAttributes[key] ?= {}
        @_updateAttributes oldAttributes[key], value
      else
        oldAttributes[key] = value

  mergedOpinionTypes: ->
    opinion_types = {}
    for type, opinion_type of @default_opinion_types
      opinion_types[type] = _.defaults(@get('opinion_types')[type] ? {}, opinion_type)
    opinion_types

  opinionTypesArray: -> _.values @get('opinion_types')

  reset: ->
    # DO NOT RUN CLEAR HERE, since then the objects 'believe', 'doubt', and 'disbelieve' are lost,
    # which are required by the BaseFactWheelView!
    @setRecursive(new Wheel().attributes)

  userOpinion: ->
    @_userOpinions()[0]

  _userOpinions: ->
    "#{type}s" for type, opinionType of @get('opinion_types') when opinionType.is_user_opinion

  toJSON: ->
    _.extend {}, super(),
      opinion_types_array: @opinionTypesArray()
