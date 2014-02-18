ReactComments = React.createBackboneClass
  displayName: 'ReactComments'
  changeOptions: 'add remove reset sort sync request'

  componentWillMount: ->
    @model().fetchIfUnloaded()

  render: ->
    _div [],
      ReactLoadingIndicator
        model: @model()
      @model().map (comment) =>
        ReactComment
          model: comment
          key: comment.get('id')
          fact_opinionators: @model().fact.getOpinionators()


window.ReactDiscussion = React.createBackboneClass
  displayName: 'ReactDiscussion'

  getInitialState: ->
    step: 0

  render: ->
    _div ['discussion'
          key: @state.step],
      if Factlink.Global.can_haz.sidebar_manual_reload?
        _div [],
          _span [style: {float: 'right'}],
            "##{@state.step}"
          _button [onClick: => @setState step: @state.step + 1],
            'Refresh'
      _div ['top-annotation'],
        _div ['top-annotation-text'],
          if @model().get('displaystring')
            @model().get('displaystring')
          else
            ReactLoadingIndicator()
        if Factlink.Global.can_haz.opinions_of_users_and_comments
          ReactOpinionateArea
            model: @model().getOpinionators()
      if Factlink.Global.signed_in
        ReactAddComment
          model: @model().comments()
          initiallyFocus: @props.initiallyFocusAddComment
      else
        ReactOpinionHelp()
      ReactComments
        model: @model().comments()
