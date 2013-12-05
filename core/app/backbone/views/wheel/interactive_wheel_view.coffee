class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @model.setActiveOpinionType 'no_vote'
    else
      @model.setActiveOpinionType opinion_type
