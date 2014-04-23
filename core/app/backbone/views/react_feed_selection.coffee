window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feedChoice: 'global'
    feeds:
      global: new GlobalFeedActivities
      personal: new PersonalFeedActivities
      discussions: new DiscussionsFeedActivities


  _handleFeedChoiceChange: (e) ->
    if(e.target.checked)
      @setState
        feedChoice: e.target.value

  _toggle_create_challenge: ->
    @setState show_create_challenge: !@state.show_create_challenge

  _postChallenge: ->
    fact = new Fact
      displaystring: @refs.challengeDescription.getDOMNode().value
      site_title: @refs.challengeName.getDOMNode().value
      site_url: 'kennisland_challenge'

    fact.save {},
      success: =>
        @refs.challengeDescription.getDOMNode().value = ''
        @refs.challengeName.getDOMNode().value = ''
        Factlink.notificationCenter.success 'Challenge created!'
      error: ->
        Factlink.notificationCenter.error 'Could not create challenge, please try again.'

  render: ->
    _div [],
      if currentSession.signedIn()
        [
          _div ['feed-selection-row'],
            if window.is_kennisland
              [
                _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'discussions', id: 'FeedChoice_Discussions', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='discussions' ]
                _label [ htmlFor: 'FeedChoice_Discussions' ],
                  'Challenges'
              ]
            _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'global', id: 'FeedChoice_Global', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='global'  ]
            _label [ htmlFor: 'FeedChoice_Global' ],
              'Global'

            _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'personal', id: 'FeedChoice_Personal', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='personal' ]
            _label [ htmlFor: 'FeedChoice_Personal' ],
              'Personal'


            if window.is_kennisland
              _button ['button-success feed-selection-install-extension-button', onClick: @_toggle_create_challenge],
                "Create challenge"
            else
              _div ['feed-selection-install-extension-button'],
                ReactInstallExtensionOrBookmarklet()

          if window.is_kennisland & @state.show_create_challenge
            _div ['challenges-create'],
              _input [
                "challenge-name-input"
                ref: 'challengeName'
                placeholder: 'Name'
              ]
              ReactTextArea
                ref: 'challengeDescription'
                placeholder: 'Describe the challenge'
                storageKey: 'createChallengeDescription'
              _button ["button-confirm", onClick: @_postChallenge],
                "Create challenge"
        ]

      ReactFeedActivitiesAutoLoading
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice
