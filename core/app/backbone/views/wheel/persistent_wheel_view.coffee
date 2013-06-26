class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (optionType, e)->
    @trigger 'opinionSet'

    @updateTo '1.0',
      believe: getHash opinionType.type, 'believe'
      disbelieve: getHash opinionType.type, 'disbelieve'
      doubt: getHash opinionType.type, 'doubt'

    $("input[name=opinion][value=#{opinionType.type}s]")
      .prop 'checked', true

getHash = (selectedType, type)->
  if selectedType == type
    selected
  else
    notSelected

selected =
  percentage: 100
  is_user_opinion: true

notSelected =
  percentage: 0
  is_user_opinion: false
