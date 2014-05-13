window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'
  mixins: [UpdateOnSignInOrOutMixin]

  getInitialState: ->
    feedChoice: 'global'
    feeds:
      global: new GlobalFeedActivities
      personal: new PersonalFeedActivities
      discussions_admin: new DiscussionsFeedActivities

  _handleFeedChoiceChange: (e) ->
    if(e.target.checked)
      @setState
        feedChoice: e.target.value

  render: ->
    _div [],
      if currentSession.signedIn()
        _div ['feed-selection-row'],
          ReactToggleButton
            name: 'FeedChoice'
            value:'global'
            checked: @state.feedChoice == 'global'
            onChange: @_handleFeedChoiceChange
            'Global'
          ReactToggleButton
            name: 'FeedChoice'
            value:'personal'
            checked: @state.feedChoice == 'personal'
            onChange: @_handleFeedChoiceChange
            'Personal'

          if currentSession.user().get('admin')
            ReactToggleButton
              name: 'FeedChoice'
              value: 'discussions_admin'
              checked: @state.feedChoice == 'discussions_admin'
              onChange: @_handleFeedChoiceChange
              'Discussions (admin)'

          _div ['feed-selection-install-extension-button'],
            ReactInstallExtensionOrBookmarklet()

      ReactFeedActivitiesAutoLoading
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice
