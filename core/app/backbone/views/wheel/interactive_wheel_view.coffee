class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    fact_id = @options.fact.id

    if @model.isUserOpinion(opinion_type)
      @unsetActiveOpinionType fact_id, opinion_type,
        error: ->
          FactlinkApp.NotificationCenter.error "Something went wrong while removing your opinion on the Factlink, please try again."
    else
      @setActiveOpinionType fact_id, opinion_type,
        error: ->
          FactlinkApp.NotificationCenter.error "Something went wrong while setting your opinion on the Factlink, please try again."

  setActiveOpinionType: (fact_id, opinion_type, options={}) ->
    @model.turnOnActiveOpinionType opinion_type
    $.ajax
      url: "/facts/#{fact_id}/opinion/#{opinion_type}s.json"
      type: "POST"
      success: (data) =>
        @model.updateTo data.authority, data.opinion_types
        mp_track "Factlink: Opinionate",
          factlink: @options.fact.id
          opinion: opinion_type

        options.success?()

      error: =>
        # TODO: This is not a proper undo. Should be restored to the current
        #       state when the request fails.
        @model.turnOffActiveOpinionType opinion_type
        options.error?()

  unsetActiveOpinionType: (fact_id, opinion_type, options={}) ->
    @model.turnOffActiveOpinionType opinion_type
    $.ajax
      type: "DELETE"
      url: "/facts/#{fact_id}/opinion.json"
      success: (data) =>
        @model.updateTo data.authority, data.opinion_types
        mp_track "Factlink: De-opinionate",
          factlink: @options.fact.id
        options.success?()

      error: =>
        @model.turnOnActiveOpinionType opinion_type
        options.error?()
