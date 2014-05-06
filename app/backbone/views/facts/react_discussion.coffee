new_comment_id = 0
ReactComments = React.createBackboneClass
  displayName: 'ReactComments'
  changeOptions: 'add remove reset sort sync request'

  refetchComments : ->
    @model().fetchIfUnloadedFor(window.currentSession.user().get('username'))

  componentWillMount: ->
    @refetchComments()
    window.currentSession.user().on 'change:username', @refetchComments, @

  componentWillUnmount: ->
    window.currentSession.user().off null, null, @

  render: ->
    _div [],
      if @model.length == 0
        _div ['loading-indicator-centered'],
          ReactLoadingIndicator
            model: @model()
      @model().map (comment) =>
        ReactComment
          model: comment
          tally: comment.argumentTally() # hack to allow use BackboneMixin
          key: comment.get('id') || ('new' + new_comment_id++)
          fact_opinionators: @model().fact.getOpinionators()


ReactCollapsedText = React.createClass
  displayName: 'ReactCollapsedText'

  getInitialState: ->
    expanded: false

  render: ->
    return _span [], @props.text if @props.text.length <= @props.size

    if @state.expanded
      _span [],
        @props.text
        ' '
        _a [
          onClick: => @setState expanded: false
        ],
          '(less)'
    else
      _span [],
        @props.text.substring 0, @props.size
        '\u2026 '
        _a [
          onClick: => @setState expanded: true
        ],
          '(more)'


window.ReactDiscussionSidebar = React.createBackboneClass
  displayName: "ReactDiscussionSidebar"
  render: ->
    _div ['discussion'],
      ReactSidebarLogin()
      @transferPropsTo ReactDiscussionStandalone()

window.ReactDiscussionStandalone = React.createBackboneClass
  displayName: 'ReactDiscussionStandalone'

  render: ->
    _div [],
      ReactTopAnnotation
        model: @model()
      ReactOpinionateArea
        model: @model().getOpinionators()
      ReactAddAnecdoteOrComment
        comments: @model().comments()
        initiallyFocus: @props.initiallyFocusAddComment
        site_url: @props.site_url
      ReactComments
        model: @model().comments()
