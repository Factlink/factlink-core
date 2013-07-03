class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinionType) ->
    fact_id = @options.fact.id

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

  toggleActiveOpinionType: (opinionType) ->
    oldAuthority = @model.get("authority")
    updateObj = {}
    _.each @model.get('opinion_types'), (oldOpinionType) ->
      updateObj[oldOpinionType.type] = _.clone(oldOpinionType)
      unless opinionType.is_user_opinion
        updateObj[oldOpinionType.type].is_user_opinion = false
      if oldOpinionType == opinionType
        updateObj[oldOpinionType.type].is_user_opinion = !opinionType.is_user_opinion

    @updateTo oldAuthority, updateObj
