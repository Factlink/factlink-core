window.ReactAddComment = React.createBackboneClass
  displayName: 'ReactAddComment'

  getInitialState: ->
    text: sessionStorage?["add_comment_to_fact_#{@model().fact.id}"] || ''
    searchOpened: false

  _changeText: (text) ->
    @setState text: text
    if sessionStorage?
      sessionStorage["add_comment_to_fact_#{@model().fact.id}"] = text

  render: ->
    _div ['add-comment-container'],
      _span ['add-comment-arrow']
      _div ['add-comment'],
        _div ['add-comment-question'],
          'What do you think?'
        ReactTextArea
          ref: 'textarea'
          value: @state.text
          onChange: (text) => @_changeText text
          onSubmit: => @_submit()
        _div [
          'add-comment-controls'
          'add-comment-controls-visible' if @_comment().isValid()
        ],
          _button ['button-confirm button-small add-comment-post-button'
            onClick: => @_submit()
          ],
            Factlink.Global.t.post_argument
          ReactShareFactSelection
            ref: 'share_fact_selection'
            model: @model().fact
          if @state.searchOpened
            _a [
              href: 'javascript:0'
              onClick: => @setState searchOpened: false
            ],
              'Close search'
          else
            _a [
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

    @_changeText ''

    @model().unshift(comment)
    comment.save {},
      success: =>
        mp_track "Factlink: Added comment",
          factlink_id: @model().fact.id
      error: =>
        @model().remove(comment)
        FactlinkApp.NotificationCenter.error 'Your comment could not be posted, please try again.'

    @model().fact.share @refs.share_fact_selection.selectedProviderNames(), comment.get('content'),
      error: =>
        FactlinkApp.NotificationCenter.error "Error when sharing"

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
