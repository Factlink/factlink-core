class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    fact_id = @options.fact.id

    if @model.isUserOpinion(opinion_type)
      @unsetActiveOpinionType fact_id, opinion_type
    else
      @setActiveOpinionType fact_id, opinion_type

  setActiveOpinionType: (fact_id, opinion_type) ->
    @turnOnActiveOpinionType opinion_type
    $.ajax
      url: "/facts/#{fact_id}/opinion/#{opinion_type}s.json"
      type: "POST"
      success: (data) =>
        @model.updateTo data.authority, data.opinion_types
        mp_track "Factlink: Opinionate",
          factlink: @options.fact.id
          opinion: opinion_type

      error: =>
        # TODO: This is not a proper undo. Should be restored to the current
        #       state when the request fails.
        @turnOffActiveOpinionType opinion_type
        alert "Something went wrong while setting your opinion on the Factlink, please try again"

  unsetActiveOpinionType: (fact_id, opinion_type) ->
    @turnOffActiveOpinionType opinion_type
    $.ajax
      type: "DELETE"
      url: "/facts/#{fact_id}/opinion.json"
      success: (data) =>
        @model.updateTo data.authority, data.opinion_types
        mp_track "Factlink: De-opinionate",
          factlink: @options.fact.id

      error: =>
        @turnOnActiveOpinionType opinion_type
        alert "Something went wrong while removing your opinion on the Factlink, please try again"

  turned_off_topinion_types: ->
    believe:    is_user_opinion: false
    disbelieve: is_user_opinion: false
    doubt:      is_user_opinion: false

  turnOffActiveOpinionType: (toggle_type) ->
    @model.updateTo @model.get("authority"), @turned_off_topinion_types()

  turnOnActiveOpinionType: (toggle_type) ->
    new_opinion_types = @turned_off_topinion_types()
    new_opinion_types[toggle_type].is_user_opinion = true

    @model.updateTo @model.get("authority"), new_opinion_types
