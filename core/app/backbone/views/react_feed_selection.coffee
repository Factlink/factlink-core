ReactInstallExtensionButton = React.createClass
  displayName: 'ReactInstallExtensionButton'

  render: ->
    _div [],
      _div ['visible-when-chrome'],
        _a ['button-success', href: 'javascript:chrome.webstore.install()'],
          'Install Factlink for Chrome'
      _div ['visible-when-firefox'],
        _a ['button-success', href: 'https://static.factlink.com/extension/firefox/factlink-latest.xpi'],
          'Install Factlink for Firefox'
      _div ['visible-when-safari'],
        _a ['button-success', href: 'https://static.factlink.com/extension/firefox/factlink.safariextz'],
          'Install Factlink for Safari'

window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feedChoice: 'global'
    feeds:
      global: new GlobalFeedActivities
      personal: new PersonalFeedActivities


  handleFeedChoiceChange: (e) ->
    if(e.target.checked)
      @setState
        feedChoice: e.target.value

  render: ->
    _div [],
      if FactlinkApp.signedIn()
        _div ['feed-selection-row'],
          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'global', id: 'FeedChoice_Global', onChange: @handleFeedChoiceChange, checked: @state.feedChoice=='global'  ]
          _label [ htmlFor: 'FeedChoice_Global' ],
            'Global'

          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'personal', id: 'FeedChoice_Personal', onChange: @handleFeedChoiceChange, checked: @state.feedChoice=='personal' ]
          _label [ htmlFor: 'FeedChoice_Personal' ],
            'Personal'

          _div ['feed-selection-install-extension-button'],
            ReactInstallExtensionButton()

      ReactFeedActivitiesAutoLoading
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice
