new_comment_id = 0
ReactComments = React.createBackboneClass
  displayName: 'ReactComments'
  changeOptions: 'add remove reset sort sync request'

  refetchComments : ->
    return if @model().fact.isNew() # TODO: Save a fact in the backend when submitting a comment

    @model().fetchIfUnloadedFor(window.currentUser.get('username'))

  componentWillMount: ->
    @refetchComments()
    window.currentUser.on 'change:username', @refetchComments, @

  componentWillUnmount: ->
    window.currentUser.off null, null, @

  render: ->
    _div [],
      if @model.length == 0
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
  mixins: [UpdateOnFeaturesChangeMixin] # opinions_of_users_and_comments

  render: ->
    _div ['discussion'],
      _div ['top-annotation'],
        _div ['top-annotation-text'],
          if @model().get('displaystring')
            @model().get('displaystring')
          else
            _div ["loading-indicator-centered"],
              ReactLoadingIndicator()
        if @canHaz('opinions_of_users_and_comments')
          ReactOpinionateArea
            model: @model().getOpinionators()
      ReactAddComment
        model: @model().comments()
        initiallyFocus: @props.initiallyFocusAddComment
      ReactComments
        model: @model().comments()
