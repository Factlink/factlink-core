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
        fact_id: @props.fact_id
        recently_viewed_facts: recently_viewed_facts

    @____factSearchResults

window.ReactAddComment = React.createBackboneClass
  displayName: 'ReactAddComment'
  mixins: [UpdateOnSignInMixin]

  componentDidMount: ->
    @refs.textarea.focusInput() if @props.initiallyFocus

  getInitialState: ->
    text: ''
    controlsOpened: false
    searchOpened: false
    shareProviders: {facebook: false, twitter: false}
    signinPopoverOpened: false

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
          onSubmit: @_onPostClicked
        _div [
          'add-comment-controls'
          'add-comment-controls-visible' if @state.controlsOpened
        ],
          _button ['button-confirm button-small add-comment-post-button'
            onClick: @_onPostClicked
            disabled: !@_comment().isValid()
          ],
            Factlink.Global.t.post_argument
            ReactSigninPopover
              signinPopoverOpened: @state.signinPopoverOpened
              onSignIn: @_submit
          if FactlinkApp.signedIn()
            _div [],
              ReactShareFactSelection
                model: @model().fact
                providers: @state.shareProviders
                onChange: @_onShareFactSelectionChange
              ReactSearchLink
                opened: @state.searchOpened
                onToggle: (opened) => @setState searchOpened: opened
              ReactSearchFacts
                opened: @state.searchOpened
                fact_id: @model().fact.id
                onInsert: @_onSearchInsert

  _onPostClicked: ->
    if FactlinkApp.signedIn()
      @_submit()
    else
      @setState signinPopoverOpened: !@state.signinPopoverOpened

  _onTextareaChange: (text) ->
    @setState(text: text)
    @setState(controlsOpened: true) if text.length > 0

  _onShareFactSelectionChange: (providerName, checked) ->
    @state.shareProviders[providerName] = checked
    @forceUpdate()

  _onSearchInsert: (text) ->
    @refs.textarea.insert text
    @setState searchOpened: false

  _submit: ->
    comment = @_comment()
    return unless comment.isValid()

    @model().unshift(comment)
    comment.save {},
      success: ->
        mp_track "Factlink: Added comment",
          factlink_id: comment.collection.fact.id
      error: ->
        comment.collection.remove(comment)
        FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'

    comment.share @state.shareProviders

    @setState @getInitialState()
    @refs.textarea.updateText ''

  _comment: ->
    new Comment
      content: $.trim(@state.text)
      created_by: currentUser.toJSON()

