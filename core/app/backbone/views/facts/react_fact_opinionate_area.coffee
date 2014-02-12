ReactOpinionatorsAvatar = React.createBackboneClass
  displayName: 'ReactOpinionatorsAvatar'

  render: ->
    _span ['opinionators-avatar'],
      _a [ href: @model().link(), rel:"backbone"],
        _img ["image-24px", "opinionators-avatar-image",
              src: @model().avatar_url(24)]

ReactOpinionatorsAvatars = React.createBackboneClass
  displayName: 'ReactOpinionatorsAvatars'
  changeOptions: 'add remove reset sort' + ' change'

  _opinionators: ->
    @model()
      .filter( (opinionator) => opinionator.get('type') == @props.opinion_type)

  render: ->
    number_of_places = 5

    if @_opinionators().length <= number_of_places
      take = number_of_places
      show_plus = false
    else
      take = number_of_places - 1
      show_plus = true

    _div ["fact-opinionators-#{@props.opinion_type}"],
      @_opinionators()
        .slice(0,take)
        .map (opinionator) ->
          ReactOpinionatorsAvatar
            model: opinionator.user()
            key: opinionator.get('username') + '-' + opinionator.get('type')

      if show_plus
        _span ["opinionators-more"],
          "+" + (@_opinionators().length - number_of_places + 1)


FactOpinionateButton = React.createBackboneClass
  displayName: 'FactOpinionateButton'
  changeOptions: 'add remove reset sort' + ' change'

  _onClick: ->
    @model().clickCurrentUserOpinion @props.opinion_type

  render: ->
    is_opinion = @model().opinion_for_current_user() == @props.opinion_type
    _div ["fact-opinionate-button"],
      if Factlink.Global.signed_in
        _button ["button fact-opinionate-button-#{@props.opinion_type}",
                 "spec-button-#{@props.opinion_type}",
                 'fact-opinionate-button-active' if is_opinion,
                 onClick: @_onClick],
           _i ["icon-thumbs-#{@props.opinion_type}"]
      else
        _span ["fact-opinion-indicator"],
          _i ["icon-thumbs-#{@props.opinion_type}"]

FactOpinionTallyChart = React.createClass
  displayName: 'FactOpinionTallyChart'

  render: ->
    tally_offset = 0.2
    total = @props.believes + @props.disbelieves + 2*tally_offset
    believe_percentage = 100 * (@props.believes + tally_offset) / total
    disbelieve_percentage = 100 * (@props.disbelieves + tally_offset) / total

    _table ["fact-opinion-tally-chart"],
      _tbody [],
        _tr [],
          _td ["fact-opinion-tally-chart-believers"
               style: {width: "#{believe_percentage}%"}]
          _td ["fact-opinion-tally-chart-disbelievers"
               style: {width: "#{disbelieve_percentage}%"}]

FactOpinionatorsTable = React.createBackboneClass
  displayName: 'FactOpinionatorsTable'
  changeOptions: 'add remove reset sort' + ' change'

  render: ->
    opinionTally = @model().countBy (opinionator) -> opinionator.get('type')
    _.defaults opinionTally,
      believes: 0,
      disbelieves: 0

    _div ["fact-opinionators-table"],
      _table ["fact-opinionators-table-table"],
        _tr [],
          _td ["fact-opinionators-table-believes"], opinionTally.believes
          _td [],
            FactOpinionTallyChart
              believes: opinionTally.believes
              disbelieves: opinionTally.disbelieves
          _td ["fact-opinionators-table-disbelieves"], opinionTally.disbelieves

window.ReactOpinionateArea = React.createBackboneClass
  displayName: 'ReactOpinionateArea'

  _opinionate: ->
    _div className: 'fact-opinionate',
      FactOpinionateButton
        model: @model().getOpinionators()
        opinion_type: 'believes'
      FactOpinionatorsTable
        model: @model().getOpinionators()
      FactOpinionateButton
        model: @model().getOpinionators()
        opinion_type: 'disbelieves'

  _opinionators: ->
    _div ["fact-opinionators"],
      ReactOpinionatorsAvatars
        model: @model().getOpinionators()
        opinion_type: 'believes'
      ReactOpinionatorsAvatars
        model: @model().getOpinionators()
        opinion_type: 'disbelieves'

  render: ->
    _div [''],
      @_opinionate()
      @_opinionators()
