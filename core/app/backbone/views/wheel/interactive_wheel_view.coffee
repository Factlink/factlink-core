class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.isUserOpinion(opinion_type)
      @model.unsetActiveOpinionType()
    else
      @model.setActiveOpinionType opinion_type
