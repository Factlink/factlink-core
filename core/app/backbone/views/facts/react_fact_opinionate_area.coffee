ReactOpinionatorsAvatar = React.createClass
  mixins: [
    React.BackboneMixin('user')
  ]

  displayName: 'ReactOpinionatorsAvatar'

  render: ->
    _span ['opinionators-avatar'],
      _a [ href: @props.user.link(), rel:"backbone"],
        _img ["image-24px", "opinionators-avatar-image",
              src: @props.user.avatar_url(24)]

ReactOpinionatorsAvatars = React.createClass
  displayName: 'ReactOpinionatorsAvatars'
  mixins: [
    React.BackboneMixin('model', 'add remove reset sort' + ' change')
  ]

  _opinionators: ->
    @props.model
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
            user: opinionator.user()
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
      _button [
            "button button-opinion-#{@props.opinion_type}"
            "spec-button-#{@props.opinion_type}"
            'button-opinion-active' if is_opinion
            onClick: => @refs.signinPopover.submit(=> @_onClick())
          ],
         _i ["icon-thumbs-#{@props.opinion_type}"]
         _span [''],
          'interesting'

        ReactSigninPopover
          ref: 'signinPopover'

FactOpinionatorsTable = React.createBackboneClass
  displayName: 'FactOpinionatorsTable'
  changeOptions: 'add remove reset sort' + ' change'

  render: ->
    opinionTally = @model().countBy (opinionator) -> opinionator.get('type')
    _.defaults opinionTally,
      believes: 0,
      disbelieves: 0
    opinionTallyTotal = opinionTally.believes + opinionTally.disbelieves

    _div ["fact-opinionators-table"],
      _table ["fact-opinionators-table-table"],
        _tr [],
          _td ["fact-opinionators-table-believes"], opinionTally.believes
          _td ["fact-opinionators-table-disbelieves"], opinionTally.disbelieves
          _td ["fact-opinionators-table-disbelieves"], opinionTallyTotal

window.ReactOpinionateArea = React.createBackboneClass
  displayName: 'ReactOpinionateArea'

  componentWillMount: ->
    @model().fetchIfUnloaded()

  _opinionate: ->
    _div className: 'fact-opinionate',
      FactOpinionateButton
        model: @model()
        opinion_type: 'believes'
      FactOpinionatorsTable
        model: @model()
      FactOpinionateButton
        model: @model()
        opinion_type: 'disbelieves'

  _opinionators: ->
    _div ["fact-opinionators"],
      ReactOpinionatorsAvatars
        model: @model()
        opinion_type: 'believes'
      ReactOpinionatorsAvatars
        model: @model()
        opinion_type: 'disbelieves'

  render: ->
    _div [''],
      @_opinionate()
      @_opinionators()
