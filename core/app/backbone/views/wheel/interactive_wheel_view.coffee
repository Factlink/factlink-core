class window.InteractiveWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    if @model.get('current_user_opinion') == opinion_type
      @model.saveCurrentUserOpinion 'no_vote'
    else
      @model.saveCurrentUserOpinion opinion_type
