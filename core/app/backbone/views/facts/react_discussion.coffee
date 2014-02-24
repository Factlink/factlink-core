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


window.ReactDiscussion = React.createBackboneClass
  displayName: 'ReactDiscussion'

  getInitialState: ->
    step: 0

  onChange: ->
    console.info 're-re-refresh'
    @setState step: @state.step + 1

  componentDidMount: ->
    window.currentUser.on 'change:username', @onChange, @

  componentWillUnmount: ->
    window.currentUser.off null, null, @

  render: ->
    _div ['discussion', key: @state.step],
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
      ReactAddComment
        model: @model().comments()
        initiallyFocus: @props.initiallyFocusAddComment
      ReactComments
        model: @model().comments()
