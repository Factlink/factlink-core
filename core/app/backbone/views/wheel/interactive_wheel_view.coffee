class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    fact_id = @options.fact.id

    if @model.isUserOpinion(opinion_type)
      @unsetActiveOpinionType fact_id, opinion_type
    else
      @setActiveOpinionType fact_id, opinion_type

  setActiveOpinionType: (fact_id, opinion_type) ->
    @model.turnOnActiveOpinionType opinion_type
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
        @model.turnOffActiveOpinionType opinion_type
        FactlinkApp.NotificationCenter.error "Something went wrong while setting your opinion on the Factlink, please try again."

  unsetActiveOpinionType: (fact_id, opinion_type) ->
    @model.turnOffActiveOpinionType opinion_type
    $.ajax
      type: "DELETE"
      url: "/facts/#{fact_id}/opinion.json"
      success: (data) =>
        @model.updateTo data.authority, data.opinion_types
        mp_track "Factlink: De-opinionate",
          factlink: @options.fact.id

      error: =>
        @model.turnOnActiveOpinionType opinion_type
        FactlinkApp.NotificationCenter.error "Something went wrong while removing your opinion on the Factlink, please try again."
