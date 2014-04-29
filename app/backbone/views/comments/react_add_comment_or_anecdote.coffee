ReactAddAnecdoteOrCommentKennisland = React.createClass
  displayName: 'ReactAddAnecdoteOrComment'

  getInitialState: ->
    anecdote_selected: true

  render: ->
    _div ['anecdote-or-comment'],
      _div ['anecdote-or-comment-choice'],
        _input [
          'radio-toggle-button'
          id: 'CommentChoice_Anecdote'
          type: 'radio'
          checked: @state.anecdote_selected
          onChange: (e) => @setState anecdote_selected: e.target.checked
        ]
        _label [htmlFor: 'CommentChoice_Anecdote'],
          Factlink.Global.t.anecdote.capitalize()

        _input [
          'radio-toggle-button'
          id: 'CommentChoice_Comment'
          type: 'radio'
          checked: !@state.anecdote_selected
          onChange: (e) => @setState anecdote_selected: !e.target.checked
        ]
        _label [htmlFor: 'CommentChoice_Comment', 'spec-anecdote-or-comment-select-comment'],
          'Comment'

      if @state.anecdote_selected
        @transferPropsTo ReactAddAnecdote()
      else
        @transferPropsTo ReactAddComment()

if window.is_kennisland
  window.ReactAddAnecdoteOrComment = ReactAddAnecdoteOrCommentKennisland
else
  window.ReactAddAnecdoteOrComment = ReactAddComment
