ReactOpinionatorsAvatar = React.createBackboneClass
  render: ->
    _span ['opinionators-avatar'],
      _a ["popover-link js-user-link opinionators-avatar-link"
          href: @model().get('username')
          rel:"backbone"],
        _img ["image-24px", "opinionators-avatar-image",
              src: @model().avatar_url(24)]

ReactOpinionatorsAvatars = React.createBackboneClass
  render: ->
    _div ["fact-vote-people-#{@props.type}"],
      @model()
        .filter( (vote) => vote.get('type') == @props.type)
        .map (vote) ->
          ReactOpinionatorsAvatar(model: vote.user())

window.ReactVoteArea = React.createBackboneClass
  render: ->
    _div ['fact-vote-area'],
      _div className: 'fact-vote',
        FactVoteButton
          model: @model().getVotes()
          type: 'believes'
        _div ["fact-vote-stats"],
          _table ["fact-vote-stats-table"],
            _tr [],
              _td ["fact-vote-amount-believes"], 10
              _td [],
                _table ["fact-vote-amount-graph"],
                  _tr [],
                    _td ["vote-amount-graph-believers"]
                    _td ["vote-amount-graph-disbelievers"]
              _td ["fact-vote-amount-believes"], 5
        FactVoteButton
          model: @model().getVotes()
          type: 'disbelieves'
      _div ["fact-vote-people"],
          ReactOpinionatorsAvatars
            model: @model().getVotes()
            type: 'believes'
          ReactOpinionatorsAvatars
            model: @model().getVotes()
            type: 'disbelieves'

FactVoteButton = React.createBackboneClass
  componentDidMount: ->
    # react.backbone.js doesn't listen to changing models
    @model().on 'change', => @forceUpdate()

  _onClick: ->
    @model().clickCurrentUserOpinion @props.type

  _direction: ->
   if @props.type == 'believes'
     'up'
   else
     'down'

  render: ->
    is_opinion = @model().opinion_for_current_user() == @props.type
    _div ["fact-vote-button"],
      if Factlink.Global.signed_in
        _button ["button fact-vote-button-#{@props.type}",
                 'fact-vote-button-active' if is_opinion,
                 onClick: @_onClick],
           _i ["icon-thumbs-#{@_direction()}"]
      else
        _span ["fact-vote-indicator"],
          _i ["icon-thumbs-#{@_direction()}"]
