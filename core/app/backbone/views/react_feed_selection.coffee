window.ReactFeedSelection = React.createClass
  displayName: 'ReactFeedSelection'

  getInitialState: ->
    feedChoice: 'global'
    feeds:
      global: new GlobalFeedActivities
      personal: new PersonalFeedActivities


  handleFeedChoiceChange: (e) ->
    console.log(e,e.target,e.target.checked, e.target.value)

    if(e.target.checked)
      @setState
        feedChoice: e.target.value

  render: ->
    _div [],
      _div [],
        _input [ type: 'radio', name: 'FeedChoice', value: 'global', id: 'FeedChoice_Global', onChange: @handleFeedChoiceChange, checked: @state.feedChoice=='global'  ]
        _label [ htmlFor: 'FeedChoice_Global' ],
          'Global'

        _input [ type: 'radio', name: 'FeedChoice', value: 'personal', id: 'FeedChoice_Personal', onChange: @handleFeedChoiceChange, checked: @state.feedChoice=='personal' ]
        _label [ htmlFor: 'FeedChoice_Personal' ],
          'Personal'

      ReactFeedActivities
        model: @state.feeds[@state.feedChoice]
        key: @state.feedChoice
