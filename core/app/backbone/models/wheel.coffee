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
    @_recursivelyUpdateAttributes @attributes, attributes

  _recursivelyUpdateAttributes: (oldAttributes, newAttributes) ->
    for key, value of newAttributes
      if typeof value is 'object'
        oldAttributes[key] ?= {}
        @_recursivelyUpdateAttributes oldAttributes[key], value
      else
        oldAttributes[key] = value

  mergedOpinionTypes: ->
    opinion_types = {}
    for type, opinion_type of @default_opinion_types
      opinion_types[type] = _.defaults(@get('opinion_types')[type] ? {}, opinion_type)
    opinion_types

  reset: ->
    # DO NOT RUN CLEAR HERE, since then the objects 'believe', 'doubt', and 'disbelieve' are lost,
    # which are required by the BaseFactWheelView!
    # TODO above warning isn't true anymore, see if we can make this simpler now
    @setRecursive(new Wheel().attributes)

  isUserOpinion: (type) -> @get('opinion_types')[type].is_user_opinion

  userOpinionWithS: -> @userOpinion()

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

  turned_off_opinion_types: ->
    believe:    is_user_opinion: false
    disbelieve: is_user_opinion: false
    doubt:      is_user_opinion: false

  turnOffActiveOpinionType: ->
    @updateTo @get("authority"), @turned_off_opinion_types()

  turnOnActiveOpinionType: (toggle_type) ->
    new_opinion_types = @turned_off_opinion_types()
    new_opinion_types[toggle_type].is_user_opinion = true

    @updateTo @get("authority"), new_opinion_types

  setActiveOpinionType: (opinion_type, options={}) ->
    fact_id = @get('fact_id')
    @turnOnActiveOpinionType opinion_type
    $.ajax
      url: "/facts/#{fact_id}/opinion/#{opinion_type}s.json"
      type: "POST"
      success: (data) =>
        @updateTo data.authority, data.opinion_types
        mp_track "Factlink: Opinionate",
          factlink: fact_id
          opinion: opinion_type
        options.success?()
      error: =>
        # TODO: This is not a proper undo. Should be restored to the current
        #       state when the request fails.
        @turnOffActiveOpinionType()
        options.error?()

  unsetActiveOpinionType: (opinion_type, options={}) ->
    fact_id = @get('fact_id')
    @turnOffActiveOpinionType()
    $.ajax
      type: "DELETE"
      url: "/facts/#{fact_id}/opinion.json"
      success: (data) =>
        @updateTo data.authority, data.opinion_types
        mp_track "Factlink: De-opinionate",
          factlink: fact_id
        options.success?()
      error: =>
        @turnOnActiveOpinionType opinion_type
        options.error?()
