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

  render: ->
    _div ['discussion'],
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
          focus: @props.focusAddComment
      else
        ReactOpinionHelp()
      ReactComments
        model: @model().comments()
