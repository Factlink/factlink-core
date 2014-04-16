window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feedChoice: 'global'
    feeds:
      global: new GlobalFeedActivities
      personal: new PersonalFeedActivities


  _handleFeedChoiceChange: (e) ->
    if(e.target.checked)
      @setState
        feedChoice: e.target.value

  _toggle_create_challenge: ->
    console.log 'hey', @state
    @setState show_create_challenge: !@state.show_create_challenge

  render: ->
    _div [],
      if currentSession.signedIn()
        [
          _div ['feed-selection-row'],
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
              _input ["challenge-name-input", id: 'challenge-name', placeholder: 'Challenge name']
              ReactTextArea
                id: 'challenge-description'
                ref: 'textarea'
                placeholder: 'Describe the challenge'
              _button ["button-confirm"],
                "post"

        ]

      ReactFeedActivitiesAutoLoading
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice
