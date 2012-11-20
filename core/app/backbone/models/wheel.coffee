class window.Wheel extends Backbone.Model
  defaults:
    opinion_types: {}
    authority: '0.0'

  default_opinion_types:
    believe:
      type: 'believe'
      groupname: Factlink.Global.t.fact_believe_opinion.titleize()
      color: "#98d100"
      is_user_opinion: false
      percentage: 33
    doubt:
      type: 'doubt'
      groupname: Factlink.Global.t.fact_doubt_opinion.titleize()
      color: "#36a9e1"
      is_user_opinion: false
      percentage: 33
    disbelieve:
      type: 'disbelieve'
      groupname: Factlink.Global.t.fact_disbelieve_opinion.titleize()
      color: "#e94e1b"
      is_user_opinion: false
      percentage: 33

  getOpinionTypes: ->
    @opinion_types ||= _(@default_opinion_types).map (opinion_type) =>
      _.defaults(@get('opinion_types')[opinion_type.type] ? {}, opinion_type)

  toJSON: ->
    originalAttributes = super()
    _.extend({}, originalAttributes,
      opinion_types: @getOpinionTypes()
    )
