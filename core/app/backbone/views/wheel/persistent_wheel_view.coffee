class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @setCurrentUserOpinion null
    else
      @setCurrentUserOpinion opinion_type
