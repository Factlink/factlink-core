window.ReactAddComment = React.createBackboneClass
  displayName: 'ReactAddComment'

  getInitialState: ->
    text: ''
    controlsOpened: false
    searchOpened: false
    shareProviders: {facebook: false, twitter: false}

  render: ->
    _div ['add-comment-container'],
      _span ['add-comment-arrow']
      _div ['add-comment spec-add-comment-form'],
        _div ['add-comment-question'],
          'What do you think?'
        ReactTextArea
          ref: 'textarea'
          storageKey: "add_comment_to_fact_#{@model().fact.id}"
          onChange: (text) =>
            @setState(text: text)
            @setState(controlsOpened: true) if text.length > 0
          onSubmit: => @_submit()
        _div [
          'add-comment-controls'
          'add-comment-controls-visible' if @state.controlsOpened
        ],
          _button ['button-confirm button-small add-comment-post-button'
            onClick: => @_submit()
            disabled: !@_comment().isValid()
          ],
            Factlink.Global.t.post_argument
          ReactShareFactSelection
            model: @model().fact
            providers: @state.shareProviders
            onChange: (providerName, checked) =>
              @state.shareProviders[providerName] = checked
              @forceUpdate()
          if @state.searchOpened
            _a [
              href: 'javascript:0'
              onClick: => @setState searchOpened: false
            ],
              'Close search'
          else
            _a ['spec-open-search-facts-link'
              href: 'javascript:0'
              onClick: => @setState searchOpened: true
            ],
              "Search for #{Factlink.Global.t.factlinks} (beta)"
          if @state.searchOpened
            _div ['add-comment-search-facts'],
              ReactFactSearch
                model: @_factSearchResults()
                onInsert: (text) =>
                  @refs.textarea.insert text
                  @setState searchOpened: false

  _submit: ->
    comment = @_comment()
    return unless comment.isValid()

    @model().unshift(comment)
    comment.save {},
      success: =>
        mp_track "Factlink: Added comment",
          factlink_id: @model().fact.id
      error: =>
        @model().remove(comment)
        FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'

    comment.share @state.shareProviders

    @setState @getInitialState()
    @refs.textarea.updateText ''

  _comment: ->
    new Comment
      content: $.trim(@state.text)
      created_by: currentUser.toJSON()

  _factSearchResults: ->
    unless @____factSearchResults
      recently_viewed_facts = new RecentlyViewedFacts
      recently_viewed_facts.fetch()

      @____factSearchResults = new FactSearchResults [],
        fact_id: @model().fact.id
        recently_viewed_facts: recently_viewed_facts

    @____factSearchResults
