ReactAddAnecdoteOrCommentKennisland = React.createClass
  displayName: 'ReactAddAnecdoteOrComment'

  getInitialState: ->
    anecdote_selected: true

  render: ->
    _div ['anecdote-or-comment'],
      _div ['anecdote-or-comment-choice'],
        ReactToggleButton
          name: 'CommentChoice'
          value: 'Anecdote'
          checked: @state.anecdote_selected
          onChange: (e) => @setState anecdote_selected: e.target.checked
          Factlink.Global.t.anecdote.capitalize()

        ReactToggleButton
          name: 'CommentChoice'
          value: 'Comment'
          checked: !@state.anecdote_selected
          onChange: (e) => @setState anecdote_selected: !e.target.checked
          'Comment'

      if @state.anecdote_selected
        @transferPropsTo ReactAddAnecdote()
      else
        @transferPropsTo ReactAddComment()

if window.is_kennisland
  window.ReactAddAnecdoteOrComment = ReactAddAnecdoteOrCommentKennisland
else
  window.ReactAddAnecdoteOrComment = ReactAddComment
