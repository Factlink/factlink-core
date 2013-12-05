class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @model.unsetActiveOpinionType()
    else
      @model.setActiveOpinionType opinion_type
