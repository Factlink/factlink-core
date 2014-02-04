ReactOpinionatorsAvatar = React.createBackboneClass
  displayName: 'ReactOpinionatorsAvatar'

  render: ->
    _span ['opinionators-avatar'],
      _a ["opinionators-avatar-link"
          href: @model().link()
          rel:"backbone"],
        _img ["image-24px", "opinionators-avatar-image",
              src: @model().avatar_url(24)]

ReactOpinionatorsAvatars = React.createBackboneClass
  displayName: 'ReactOpinionatorsAvatar'

  componentDidMount: ->
    # react.backbone.js doesn't listen to changing models
    @model().on 'change', => @forceUpdate()

  render: ->
    _div ["fact-vote-people-#{@props.type}"],
      @model()
        .filter( (vote) => vote.get('type') == @props.type)
        .map (vote) ->
          ReactOpinionatorsAvatar(model: vote.user())


FactVoteButton = React.createBackboneClass
  displayName: 'FactVoteButton'
  componentDidMount: ->
    # react.backbone.js doesn't listen to changing models
    @model().on 'change', => @forceUpdate()

  _onClick: ->
    @model().clickCurrentUserOpinion @props.type

  render: ->
    is_opinion = @model().opinion_for_current_user() == @props.type
    _div ["fact-vote-button"],
      if Factlink.Global.signed_in
        _button ["button fact-vote-button-#{@props.type}",
                 "spec-button-#{@props.type}",
                 'fact-vote-button-active' if is_opinion,
                 onClick: @_onClick],
           _i ["icon-thumbs-#{@props.type}"]
      else
        _span ["fact-vote-indicator"],
          _i ["icon-thumbs-#{@props.type}"]


FactVoteAmountGraph = React.createClass
  displayName: 'FactVoteAmountGraph'

  render: ->
    vote_padding = 0.2
    total = @props.believes + @props.disbelieves + 2*vote_padding
    believe_percentage = Math.ceil(100 * (@props.believes + vote_padding)/ total)
    disbelieve_percentage = 100-believe_percentage

    _table ["fact-vote-amount-graph"],
      _tr [],
        _td ["vote-amount-graph-believers"
             style: {width: "#{believe_percentage}%"}]
        _td ["vote-amount-graph-disbelievers"
             style: {width: "#{disbelieve_percentage}%"}]

FactVoteStatsTable = React.createBackboneClass
  displayName: 'FactVoteStatsTable'

  componentDidMount: ->
    # react.backbone.js doesn't listen to changing models
    @model().on 'change', => @forceUpdate()

  render: ->
    votes = @model().countBy (vote) -> vote.get('type')
    _.defaults votes,
      believes: 0,
      disbelieves: 0

    _div ["fact-vote-stats"],
      _table ["fact-vote-stats-table"],
        _tr [],
          _td ["fact-vote-amount-believes"], votes.believes
          _td [],
            FactVoteAmountGraph
              believes: votes.believes
              disbelieves: votes.disbelieves
          _td ["fact-vote-amount-disbelieves"], votes.disbelieves

window.ReactVoteArea = React.createBackboneClass
  displayName: 'ReactVoteArea'

  _voting: ->
    _div className: 'fact-vote',
      FactVoteButton
        model: @model().getVotes()
        type: 'believes'
      FactVoteStatsTable
        model: @model().getVotes()
      FactVoteButton
        model: @model().getVotes()
        type: 'disbelieves'

  _voters: ->
    _div ["fact-vote-people"],
      ReactOpinionatorsAvatars
        model: @model().getVotes()
        type: 'believes'
      ReactOpinionatorsAvatars
        model: @model().getVotes()
        type: 'disbelieves'

  render: ->
    _div ['fact-vote-area'],
      @_voting()
      @_voters()
