window.ReactSubComment = React.createBackboneClass
  render: ->
    R.div {},
      R.div className: "discussion-evidenceish-content discussion-evidenceish-text",
        @model().get('formatted_comment_content')
      R.div className: "comment-bottom",
        R.ul className: "comment-bottom-actions",
          R.li className: "comment-bottom-action comment-bottom-action-time",
            R.i className: "icon-time"
            @model().get('time_ago')
            ' '
            Factlink.Global.t.ago
          if @model().can_destroy()
            R.li className: "comment-bottom-action comment-bottom-action-delete",
              window.ReactDeleteButton
                model: @model()
                onDelete: -> @model.destroy wait: true
