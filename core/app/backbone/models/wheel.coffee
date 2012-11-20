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

  getOpinionTypes: ->
    @opinion_types ?= @mergeOpinionTypes()

  mergeOpinionTypes: ->
    opinion_types = {}
    for type, opinion_type of @default_opinion_types
      opinion_types[type] = _.defaults(@get('opinion_types')[type] ? {}, opinion_type)    
    opinion_types

  toJSON: ->
    originalAttributes = super()
    _.extend({}, originalAttributes,
      opinion_types: @getOpinionTypes()
    )
