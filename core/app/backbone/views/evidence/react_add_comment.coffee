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
    unless @____factSearchResults
      recently_viewed_facts = new RecentlyViewedFacts
      recently_viewed_facts.fetch()

      @____factSearchResults = new FactSearchResults [],
        recently_viewed_facts: recently_viewed_facts

    @____factSearchResults

window.ReactAddComment = React.createBackboneClass
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

  render: ->
    _div ['add-comment-container comment-container'],
      _span ['add-comment-arrow']
      _div ['add-comment spec-add-comment-form'],
        _div ['add-comment-question'],
          'What do you think?'
        ReactTextArea
          ref: 'textarea'
          storageKey: "add_comment_to_fact_#{@model().fact.id}"
          onChange: @_onTextareaChange
          onSubmit: => @refs.signinPopover.submit(=> @_submit())
        _div [
          'add-comment-controls'
          'add-comment-controls-visible' if @state.controlsOpened
        ],
          _button ['button-confirm button-small add-comment-post-button'
            onClick: => @refs.signinPopover.submit(=> @_submit())
            disabled: !@_comment().isValid()
            ref: 'post'
          ],
            Factlink.Global.t.post_comment
            ReactSigninPopover
              ref: 'signinPopover'
          _div [],
            ReactSearchLink
              opened: @state.searchOpened
              onToggle: (opened) => @setState searchOpened: opened
            ReactSearchFacts
              opened: @state.searchOpened
              onInsert: @_onSearchInsert

  _onTextareaChange: (text) ->
    @setState(text: text)
    @setState(controlsOpened: true) if text.length > 0
    mp_track "Annotation: Started typing"

  _onSearchInsert: (text) ->
    @refs.textarea.insert text
    @setState searchOpened: false

  _submit: ->
    comment = @_comment()
    return unless comment.isValid()

    @model().unshift(comment)
    comment.saveWithFactAndWithState {},
      success: ->
        mp_track "Annotation: Added comment",
          factlink_id: comment.collection.fact.id

    @setState @getInitialState()
    @refs.textarea.updateText ''

  _comment: ->
    new Comment
      content: $.trim(@state.text)
      created_by: currentSession.user().toJSON()
