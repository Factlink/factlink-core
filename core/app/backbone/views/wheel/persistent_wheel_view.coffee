class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (opinionType) ->
    @trigger 'opinionSet'

    @updateTo '1.0',
      believe: getHash opinionType.type, 'believe'
      disbelieve: getHash opinionType.type, 'disbelieve'
      doubt: getHash opinionType.type, 'doubt'

    # TODO: Remove global jQuery call. You can currently have only one
    #       persistent wheel view per page
    #       Even better: look into this, probably is not needed.
    $("input[name=opinion][value=#{opinionType.type}s]")
      .prop 'checked', true

getHash = (selectedType, type)->
  if selectedType == type
    percentage: 100
    is_user_opinion: true
  else
    percentage: 0
    is_user_opinion: false
