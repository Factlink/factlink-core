class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinionType) ->
    fact_id = @options.fact.id

    @toggleActiveOpinionType opinionType.type
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
          @toggleActiveOpinionType opinionType.type
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
          @toggleActiveOpinionType opinionType.type
          alert "Something went wrong while removing your opinion on the Factlink, please try again"

  toggleActiveOpinionType: (toggle_type) ->
    new_opinion_types = {}

    opinion_types = @model.get('opinion_types')

    activating_an_opinion = not opinion_types[toggle_type].is_user_opinion

    _.each opinion_types, (old_opinion_type) ->

      new_opinion_type = {}
      new_opinion_type.percentage = old_opinion_type.percentage

      new_opinion_type.is_user_opinion =
        if old_opinion_type.type == toggle_type
          not old_opinion_type.is_user_opinion
        else
          false

      new_opinion_types[old_opinion_type.type] = new_opinion_type

    @updateTo @model.get("authority"), new_opinion_types
