class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinionType, e) ->
    fact_id = @options.fact.id

    if fact_id?
      @toggleActiveOpinionType opinionType
      if opinionType.is_user_opinion
        $.ajax
          url: "/facts/" + fact_id + "/opinion/" + opinionType.type + "s.json"
          type: "POST"
          success: (data) =>
            @updateTo data.authority, data.opinion_types
            mp_track "Factlink: Opinionate",
              factlink: @options.fact.id
              opinion: opinionType.type

          error: =>
            @toggleActiveOpinionType opinionType
            alert "Something went wrong while setting your opinion on the Factlink, please try again"

      else
        $.ajax
          type: "DELETE"
          url: "/facts/" + fact_id + "/opinion.json"
          success: (data) =>
            @updateTo data.authority, data.opinion_types
            mp_track "Factlink: De-opinionate",
              factlink: @options.fact.id

          error: =>
            @toggleActiveOpinionType opinionType
            alert "Something went wrong while removing your opinion on the Factlink, please try again"
