class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @model.setCurrentUserOpinion null
    else
      @model.setCurrentUserOpinion opinion_type
