class window.InteractiveWheelView extends BaseFactWheelView
  getFactId: ->
    if @model.get("fact_id")
      @model.get "fact_id"
    else
      @options.fact.id

  clickOpinionType: (opinionType, e) ->
    @toggleActiveOpinionType opinionType
    if opinionType.is_user_opinion
      $.ajax
        url: "/facts/" + @getFactId() + "/opinion/" + opinionType.type + "s.json"
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
        url: "/facts/" + @getFactId() + "/opinion.json"
        success: (data) =>
          @updateTo data.authority, data.opinion_types
          mp_track "Factlink: De-opinionate",
            factlink: @options.fact.id

        error: =>
          @toggleActiveOpinionType opinionType
          alert "Something went wrong while removing your opinion on the Factlink, please try again"
