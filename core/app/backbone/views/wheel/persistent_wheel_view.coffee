class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @model.setCurrentUserOpinion 'no_vote'
    else
      @model.setCurrentUserOpinion opinion_type
