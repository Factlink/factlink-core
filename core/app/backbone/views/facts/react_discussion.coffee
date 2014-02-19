new_comment_id = 0
ReactComments = React.createBackboneClass
  displayName: 'ReactComments'
  changeOptions: 'add remove reset sort sync request'

  componentWillMount: ->
    @model().fetchIfUnloaded()

  render: ->
    _div [],
      _div ['loading-indicator-centered'],
        ReactLoadingIndicator
          model: @model()
      @model().map (comment) =>
        ReactComment
          model: comment
          key: comment.get('id') || ('new' + new_comment_id++)
          fact_opinionators: @model().fact.getOpinionators()

window.RefreshIfCurrentUserChanges = React.createClass
  getInitialState: ->
    step: 0

  componentDidMount: ->
    window.curentUser?.on 'change', @onChange, @

  componentWillUnmount: ->
    window.currentUser?.off null, null, @

  onChange: ->
    console.info 're-re-refresh'
    @setState step: @state.step + 1

  render: ->
    _div ['refresh-on-current-user-changes', key: @state.step],
      @props.children



window.ReactDiscussion = React.createBackboneClass
  displayName: 'ReactDiscussion'

  getInitialState: ->
    step: 0

  render: ->
    RefreshIfCurrentUserChanges {},
      _div ['discussion'],
        _div ['top-annotation'],
          _div ['top-annotation-text'],
            if @model().get('displaystring')
              @model().get('displaystring')
            else
              _div ["loading-indicator-centered"],
                ReactLoadingIndicator()
          if Factlink.Global.can_haz.opinions_of_users_and_comments
            ReactOpinionateArea
              model: @model().getOpinionators()
        if FactlinkApp.signedIn()
          ReactAddComment
            model: @model().comments()
            initiallyFocus: @props.initiallyFocusAddComment
        else
          ReactOpinionHelp()
        ReactComments
          model: @model().comments()
