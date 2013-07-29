class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    @trigger 'opinionSet'

    @model.set @model.parse
      authority: '1.0',
      opinion_types:
        believe: getHash opinion_type, 'believe'
        disbelieve: getHash opinion_type, 'disbelieve'
        doubt: getHash opinion_type, 'doubt'

getHash = (selectedType, type)->
  if selectedType == type
    percentage: 100
    is_user_opinion: true
  else
    percentage: 0
    is_user_opinion: false
