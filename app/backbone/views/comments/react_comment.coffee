

window.ReactComment = React.createBackboneClass
  displayName: 'ReactComment'
  mixins: [React.BackboneMixin('tally'), UpdateOnSignInOrOutMixin]
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(InterestedUsers).isRequired
    model: React.PropTypes.instanceOf(Comment).isRequired

  getInitialState: ->
    show_subcomments: undefined
    editing: false

  _show_subcomments: ->
    if @state.show_subcomments != undefined
      @state.show_subcomments
    else
      !!@model().get('sub_comments_count')

  _onDelete: ->
     @model().destroy wait: true

  _toggleSubcomments: ->
    @setState show_subcomments: !@_show_subcomments()

  _content: ->
    if @model().get('formatted_content')
      _div ["comment-content spec-comment-content",
        dangerouslySetInnerHTML: {__html: @model().get('formatted_content')}]
    else
      _div ["comment-content spec-comment-content"],
        @model().get('content')

  _separator: ->
    nbsp = "\u00a0"
    middle_dot = "\u00b7"

    "#{nbsp}#{nbsp}#{middle_dot}#{nbsp}#{nbsp}"

  _bottom: ->
    sub_comment_count = @model().get('sub_comments_count')

    _span [],
      _span ["comment-post-bottom"],
        _span ["comment-post-bottom-right"],
          if @model().can_destroy()
            ReactSlidingDeleteButton
              model: @model()
              onDelete: @_onDelete
          if @model().can_edit() && @model().can_destroy()
            @_separator()
          if @model().can_edit()
            _a ['spec-comment-edit', onClick: => @setState editing: !@state.editing],
              _i ['icon-edit comment-edit-icon']
        _a ["spec-sub-comments-link", href:"javascript:", onClick: @_toggleSubcomments],
          "(#{sub_comment_count}) Reply"

        unless window.is_kennisland
          _span [],
            @_separator()
            ReactSlidingShareButton
              model: @model()
      if @_show_subcomments()
        ReactSubComments
          model: @model().sub_comments()
          fact_opinionators: @props.fact_opinionators

  _save: ->
    @model().saveWithState()

  render: ->
    relevant = @props.tally.relevance() >= 0

    _div ["comment-container", "spec-evidence-box", "comment-irrelevant" unless relevant],
      if @state.editing
        FormClass =
          if @model().get('markup_format') == 'anecdote'
            ReactAnecdoteForm
          else
            ReactCommentForm

        FormClass
          defaultValue: @model().get('content')
          initiallyFocus: true
          onSubmit: (text) =>
            @model().set 'content', text
            @model().saveWithState()
            @setState editing: false
      else
        _div [],
          _div ["comment-votes-container"],
            ReactCommentVote
              fact_opinionators: @props.fact_opinionators
              model: @props.tally
          _div ["comment-content-container"],
            ReactCommentHeading
              fact_opinionators: @props.fact_opinionators
              model: @model()

            @_content()

            if @model().get('save_failed') == true
              ReactRetryButton onClick: @_save

      _div ["comment-subcontent-container"],
        if not @model().isNew()
          @_bottom()

ReactCommentHeading = React.createBackboneClass
  displayName: 'ReactCommentHeading'
  propTypes:
    fact_opinionators: React.PropTypes.instanceOf(InterestedUsers).isRequired
    model: React.PropTypes.instanceOf(Comment).isRequired

  render: ->
    creator = @model().creator()
    _div ['comment-post-heading'],
      ReactOpinionatedAvatar(
        user: creator
        model: @props.fact_opinionators
        size: 32
      ),
      _span ["comment-post-creator"],
          _a ["comment-post-creator-name", href: creator.link(), rel: "backbone"],
            creator.get('name')

        TimeAgo
          className: "comment-post-time"
          time: @model().get('created_at')

window.ReactOpinionatedAvatar = React.createClass
  displayName: "ReactOpinionatedAvatar"

  propTypes:
    user: React.PropTypes.instanceOf(User).isRequired
    size:  React.PropTypes.number

  render: ->
    _span ["opinionated-avatar", style: { height: @props.size + 'px' }],
      _span ["post-creator-avatar", style: { width: @props.size + 'px'}],
        _img ["avatar-image", src: @props.user.avatar_url(@props.size)]


