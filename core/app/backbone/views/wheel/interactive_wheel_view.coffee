class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    fact_id = @options.fact.id

    if @model.isUserOpinion(opinion_type)
      @model.unsetActiveOpinionType fact_id, opinion_type,
        error: ->
          FactlinkApp.NotificationCenter.error "Something went wrong while removing your opinion on the Factlink, please try again."
    else
      @model.setActiveOpinionType fact_id, opinion_type,
        error: ->
          FactlinkApp.NotificationCenter.error "Something went wrong while setting your opinion on the Factlink, please try again."
