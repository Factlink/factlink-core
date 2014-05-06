window.ReactCreateChallenge = React.createClass
  _postChallenge: ->
    fact = new Fact
      displaystring: @refs.challengeDescription.getHtml()
      site_title: @refs.challengeName.getDOMNode().value
      site_url: 'kennisland_challenge'
      group_id: @refs.challengeGroupId.state.value # they should implement a getValue

    newActivity =
      new Activity
        action: 'created_fact'
        fact: fact.toJSON()
        user: currentSession.user().toJSON()

    @props.onActivityCreated newActivity

    fact.save {},
      success: =>
        @refs.challengeDescription.updateHtml ''
        @refs.challengeName.getDOMNode().value = ''
        Factlink.notificationCenter.success 'Challenge created!'
      error: ->
        Factlink.notificationCenter.error 'Could not create challenge, please try again.'

  render: ->
    _div ['challenges-create'],
      _input [
        "challenge-name-input"
        ref: 'challengeName'
        placeholder: 'Title'
      ]
      ReactCkeditorArea
        ref: 'challengeDescription'
        placeholder: 'Describe your challenge'
        storageKey: "createChallengeDescription_#{@props.groupId}"
      _label ['challenge-group-input-label'],
        'Group: '
        _select [ref: 'challengeGroupId', defaultValue: @props.groupId],
          _option [value: null], '(no group / public)'
          currentSession.user().get('groups').map (group) =>
            _option [value: group.id],
              group.groupname
      _button ["button-confirm", onClick: @_postChallenge],
        "Create challenge"
