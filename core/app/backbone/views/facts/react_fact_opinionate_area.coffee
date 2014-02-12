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
      .filter( (opinionator) => opinionator.get('type') == @props.opinion)

  render: ->
    number_of_places = 5

    if @_opinionators().length <= number_of_places
      take = number_of_places
      show_plus = false
    else
      take = number_of_places - 1
      show_plus = true

    _div ["fact-opinionators-#{@props.opinion}"],
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
    @model().clickCurrentUserOpinion @props.opinion

  render: ->
    is_opinion = @model().opinion_for_current_user() == @props.opinion
    _div ["fact-vote-button"],
      if Factlink.Global.signed_in
        _button ["button fact-vote-button-#{@props.opinion}",
                 "spec-button-#{@props.opinion}",
                 'fact-vote-button-active' if is_opinion,
                 onClick: @_onClick],
           _i ["icon-thumbs-#{@props.opinion}"]
      else
        _span ["fact-vote-indicator"],
          _i ["icon-thumbs-#{@props.opinion}"]


FactVoteAmountGraph = React.createClass
  displayName: 'FactVoteAmountGraph'

  render: ->
    vote_padding = 0.2
    total = @props.believes + @props.disbelieves + 2*vote_padding
    believe_percentage = Math.ceil(100 * (@props.believes + vote_padding)/ total)
    disbelieve_percentage = 100-believe_percentage

    _table ["fact-vote-amount-graph"],
      _tbody [],
        _tr [],
          _td ["vote-amount-graph-believers"
               style: {width: "#{believe_percentage}%"}]
          _td ["vote-amount-graph-disbelievers"
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
          _td ["fact-vote-amount-believes"], opinionTally.believes
          _td [],
            FactVoteAmountGraph
              believes: opinionTally.believes
              disbelieves: opinionTally.disbelieves
          _td ["fact-vote-amount-disbelieves"], opinionTally.disbelieves

window.ReactOpinionateArea = React.createBackboneClass
  displayName: 'ReactOpinionateArea'

  _opinionate: ->
    _div className: 'fact-vote',
      FactOpinionateButton
        model: @model().getOpinionators()
        opinion: 'believes'
      FactOpinionatorsTable
        model: @model().getOpinionators()
      FactOpinionateButton
        model: @model().getOpinionators()
        opinion: 'disbelieves'

  _opinionators: ->
    _div ["fact-opinionators"],
      ReactOpinionatorsAvatars
        model: @model().getOpinionators()
        opinion: 'believes'
      ReactOpinionatorsAvatars
        model: @model().getOpinionators()
        opinion: 'disbelieves'

  render: ->
    _div [''],
      @_opinionate()
      @_opinionators()
