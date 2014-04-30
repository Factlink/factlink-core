ReactSearchLink = React.createClass
  displayName: 'ReactSearchLink'

  render: ->
    if @props.opened
      _a [
        href: 'javascript:0'
        onClick: => @props.onToggle?(false)
      ],
        'Close search'
    else
      _a ['spec-open-search-facts-link'
        href: 'javascript:0'
        onClick: => @props.onToggle?(true)
      ],
        "Search for #{Factlink.Global.t.factlinks} (beta)"


ReactSearchFacts = React.createClass
  displayName: 'ReactSearchFacts'

  render: ->
    return _div() unless @props.opened

    _div ['add-comment-search-facts'],
      ReactFactSearch
        model: @_factSearchResults()
        onInsert: @props.onInsert

  _factSearchResults: ->
    @____factSearchResults ?= new FactSearchResults


window.ReactAddComment = React.createClass
  displayName: 'ReactAddComment'
  mixins: [UpdateOnSignInOrOutMixin]

  componentDidMount: ->
    if @props.initiallyFocus
      # For some crazy reason, the overflow-x: hidden; is scrolled!
      # browsers scroll to focussed elements, they even scroll overflow:hidden containers
      # problem here is discussionSidebarContainer.
      # two mitigations:
      # (1) reset horizontal scroll right after focusing.  Works on chrome+FF.
      # However, this still flashes on IE11 (maybe only without gfx accel)
      # (2) delay focusing while transitioning (at least initially)
      # This ensures the browser needn't try to scroll, and works in IE11 too.

      textarea = @refs.textarea
      if  window.$.fx.off
        textarea.focusInput()
      else
        setTimeout ->
          textarea.focusInput()
          $(".discussion-sidebar-outer")[0]?.scrollLeft = 0
        , discussion_sidebar_slide_transition_duration + 100

  getInitialState: ->
    text: ''
    controlsOpened: false
    searchOpened: false

  _renderTextArea: ->
    comment_add_uid = string_hash(@props.site_url)
    #note: we'd can't rely on *any* model attributes for the uid because
    #the id is missing for new models, and everything else is missing for existing
    #but not entirely loaded models.
    ReactTextArea
      ref: 'textarea'
      storageKey: "add_comment_to_fact_#{comment_add_uid}"
      onChange: @_onTextareaChange
      onSubmit: => @refs.signinPopover.submit(=> @_submit())

  _renderSearchRegion: ->
    _div [],
      ReactSearchLink
        opened: @state.searchOpened
        onToggle: (opened) => @setState searchOpened: opened
      ReactSearchFacts
        opened: @state.searchOpened
        onInsert: @_onSearchInsert

  _renderSubmitButton: ->
    _button ['button-confirm button-small add-comment-post-button'
      onClick: => @refs.signinPopover.submit(=> @_submit())
      disabled: !@_comment().isValid()
    ],
      Factlink.Global.t.post_comment
      ReactSigninPopover
        ref: 'signinPopover'

  render: ->
    _div ['add-comment-container comment-container'],
      _div ['add-comment spec-add-comment-form'],
        _div ['add-comment-question'],
          'What do you think?'

        @_renderTextArea()
        _div [
          'add-comment-controls'
          'add-comment-controls-visible' if @state.controlsOpened
        ],
          @_renderSubmitButton()
          @_renderSearchRegion()

  _onTextareaChange: (text) ->
    @setState(text: text)
    @setState(controlsOpened: true) if text.length > 0

  _onSearchInsert: (text) ->
    @refs.textarea.insert text
    @setState searchOpened: false

  _submit: ->
    comment = @_comment()
    return unless comment.isValid()

    @props.comments.unshift(comment)
    comment.saveWithFactAndWithState {},
      success: =>
        @props.comments.fact.getOpinionators().setInterested true

    @setState @getInitialState()
    @refs.textarea.updateText ''

  _comment: ->
    new Comment
      content: $.trim(@state.text)
      created_by: currentSession.user().toJSON()
