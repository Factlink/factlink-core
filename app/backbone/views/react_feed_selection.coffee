ReactFactlinkFeedSelection = React.createClass
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

  render: ->
    _div [],
      if currentSession.signedIn()
        _div ['feed-selection-row'],
          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'global', id: 'FeedChoice_Global', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='global'  ]
          _label [ htmlFor: 'FeedChoice_Global' ],
            'Global'

          _input [ 'radio-toggle-button', type: 'radio', name: 'FeedChoice', value: 'personal', id: 'FeedChoice_Personal', onChange: @_handleFeedChoiceChange, checked: @state.feedChoice=='personal' ]
          _label [ htmlFor: 'FeedChoice_Personal' ],
            'Personal'

          _div ['feed-selection-install-extension-button'],
            ReactInstallExtensionOrBookmarklet()

      ReactFeedActivitiesAutoLoading
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice

ReactKennislandFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feed: new DiscussionsFeedActivities

  _toggle_create_challenge: ->
    @setState show_create_challenge: !@state.show_create_challenge

  addActivity: (activity) ->
    @state.feed.unshift activity

  render: ->
    _div [],
      (if currentSession.signedIn()
        [
          _div ['feed-selection-row'],
            _button ['button-success feed-selection-install-extension-button', onClick: @_toggle_create_challenge],
              (if !@state.show_create_challenge then "Create challenge" else "Cancel")

          if @state.show_create_challenge
            ReactCreateChallenge
              onActivityCreated: @addActivity
        ]
      else [])...

      ReactFeedActivitiesAutoLoading
        model: @state.feed
        key: @state.feedChoice

if window.is_kennisland
  window.ReactFeedSelection = ReactKennislandFeedSelection
else
  window.ReactFeedSelection = ReactFactlinkFeedSelection
