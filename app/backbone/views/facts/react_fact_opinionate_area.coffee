ReactOpinionatorsAvatar = React.createClass
  displayName: 'ReactOpinionatorsAvatar'

  mixins: [
    React.BackboneMixin('user')
  ]

  render: ->
    _a ["interested-avatar", href: @props.user.link(), rel:"backbone"],
      _img ["image-24px", "opinionators-avatar-image",
            src: @props.user.avatar_url(24)]

ReactOpinionatorsAvatars = React.createClass
  displayName: 'ReactOpinionatorsAvatars'
  mixins: [
    React.BackboneMixin('model', 'add remove reset sort' + ' change')
  ]

  _opinionators: ->
    @props.model

  render: ->
    number_of_places = 10

    if @_opinionators().length <= number_of_places
      take = number_of_places
      show_plus = false
    else
      take = number_of_places - 1
      show_plus = true

    _div ["interested-avatars"],
      @_opinionators()
        .slice(0,take)
        .map (opinionator) ->
          ReactOpinionatorsAvatar
            user: opinionator.user()
            key: opinionator.get('username') + '-' + opinionator.get('type')

      if show_plus
        _span ["interested-avatars-more"],
          "+" + (@_opinionators().length - number_of_places + 1)


FactInterestedButton = React.createBackboneClass
  displayName: 'FactInterestedButton'
  changeOptions: 'add remove reset sort' + ' change'

  mixins: [ UpdateOnSignInOrOutMixin ]

  render: ->
    model = @model()
    is_interested = model.is_current_user_interested()

    _button [
          "button-interesting spec-button-interesting"
          onClick: => @refs.signinPopover.submit(-> model.setInterested(!is_interested))
        ],
      _div ['button-interesting-tally'],
        model.length

      _i [
        "icon-star button-interesting-star"
        'button-interesting-star-active' if is_interested
      ]
      'interesting'

      ReactSigninPopover
        ref: 'signinPopover'

window.ReactOpinionateArea = React.createBackboneClass
  displayName: 'ReactOpinionateArea'

  componentWillMount: ->
    @model().fetchIfUnloaded()

  _opinionate: ->
    FactInterestedButton
      model: @model()
      opinion_type: 'believes'

  _opinionators: ->
    ReactOpinionatorsAvatars
      model: @model()

  render: ->
    _div ['annotation-options'],
      @_opinionate()
      @_opinionators()
