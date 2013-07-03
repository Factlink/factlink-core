class window.PersistentWheelView extends BaseFactWheelView
  clickOpinionType: (opinion_type) ->
    @trigger 'opinionSet'

    @model.updateTo '1.0',
      believe: getHash opinion_type, 'believe'
      disbelieve: getHash opinion_type, 'disbelieve'
      doubt: getHash opinion_type, 'doubt'

    # TODO: Remove global jQuery call. You can currently have only one
    #       persistent wheel view per page
    #       Even better: look into this, probably is not needed.
    $("input[name=opinion][value=#{opinion_type}s]")
      .prop 'checked', true

getHash = (selectedType, type)->
  if selectedType == type
    percentage: 100
    is_user_opinion: true
  else
    percentage: 0
    is_user_opinion: false
