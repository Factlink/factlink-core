#TODO: refactoring of this and related files.
# - don't use multiple is_user_opinion(s), but one attribute user_opinion
# - make unset state explicit.
# - simplify rest api (no need for delete!)
# - try to get rid of userOpinionWithS (facts_new_view)
# - pursue these changes into related code.

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
    @_setDefaults()

  setRecursive: (newAttributes, oldAttributes=@attributes) ->
    for key, value of newAttributes
      if typeof value is 'object'
        oldAttributes[key] ?= {}
        @setRecursive value, oldAttributes[key]
      else
        oldAttributes[key] = value

  _setDefaults: ->
    for type, opinion_type of @default_opinion_types
      @get('opinion_types')[type] ?= {}
      _.defaults @get('opinion_types')[type] , opinion_type

  clear: (options={})->
    super _.extend {}, options, silent: true
    @set new Wheel().attributes, _.pick(options, 'silent')

  isUserOpinion: (type) -> @get('opinion_types')[type].is_user_opinion

  userOpinionWithS: ->
    opinion = @userOpinion()
    opinion and (opinion + 's')

  userOpinion: ->
    @_userOpinions()[0]

  _userOpinions: ->
    type for type, opinionType of @get('opinion_types') when opinionType.is_user_opinion

  parse: (response) ->
    new_opinion_types = {}
    for type, oldOpinionType of @get('opinion_types')
      new_opinion_types[type] = _.extend _.clone(oldOpinionType), response.opinion_types[type]

    authority: response.authority
    opinion_types: new_opinion_types

  turned_off_opinion_types: ->
    believe:    is_user_opinion: false
    disbelieve: is_user_opinion: false
    doubt:      is_user_opinion: false

  turnOffActiveOpinionType: ->
    @set @parse authority: @get("authority"), opinion_types: @turned_off_opinion_types()

  turnOnActiveOpinionType: (toggle_type) ->
    new_opinion_types = @turned_off_opinion_types()
    new_opinion_types[toggle_type].is_user_opinion = true

    @set @parse authority: @get("authority"), opinion_types: new_opinion_types

  # TODO: Use @save here!!
  setActiveOpinionType: (opinion_type) ->
    @previous_opinion_type = @userOpinion()
    fact_id = @get('fact_id')
    @turnOnActiveOpinionType opinion_type
    Backbone.sync 'create', this,
      attrs: {}
      url: "/facts/#{fact_id}/opinion/#{opinion_type}s.json"
      success: (data, status, response) =>
        @set @parse data
        mp_track "Factlink: Opinionate",
          factlink: fact_id
          opinion: opinion_type
        @trigger 'sync', this, response # TODO: Remove when using Backbone sync
      error: =>
        # TODO: This is not a proper undo. Should be restored to the current
        #       state when the request fails.
        if @previous_opinion_type
          @turnOnActiveOpinionType @previous_opinion_type
        else
          @turnOffActiveOpinionType()
        FactlinkApp.NotificationCenter.error "Something went wrong while setting your opinion on the Factlink, please try again."

  # TODO: Use @save here!!
  unsetActiveOpinionType: ->
    @previous_opinion_type = @userOpinion()
    fact_id = @get('fact_id')
    @turnOffActiveOpinionType()
    Backbone.sync 'delete', this,
      attrs: {}
      url: "/facts/#{fact_id}/opinion.json"
      success: (data, status, response) =>
        @set @parse data
        mp_track "Factlink: De-opinionate",
          factlink: fact_id
        @trigger 'sync', this, response # TODO: Remove when using Backbone sync
      error: =>
        @turnOnActiveOpinionType @previous_opinion_type
        FactlinkApp.NotificationCenter.error "Something went wrong while removing your opinion on the Factlink, please try again."

  undoOpinion: ->
    return if @previous_opinion_type == @userOpinion()

    if @previous_opinion_type?
      @setActiveOpinionType @previous_opinion_type
    else
      @unsetActiveOpinionType()

  believe: -> @setActiveOpinionType 'believe'
  disbelieve: -> @setActiveOpinionType 'disbelieve'

