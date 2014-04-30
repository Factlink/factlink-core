window.ReactCreateChallenge = React.createClass
  _postChallenge: ->
    fact = new Fact
      displaystring: @refs.challengeDescription.getDOMNode().value
      site_title: @refs.challengeName.getDOMNode().value
      site_url: 'kennisland_challenge'

    newActivity =
      new Activity
        action: 'created_fact'
        fact: fact.toJSON()
        user: currentSession.user().toJSON()

    @props.onActivityCreated newActivity

    fact.save {},
      success: =>
        @refs.challengeDescription.updateText ''
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
      ReactTextArea
        ref: 'challengeDescription'
        placeholder: 'Describe your challenge'
        storageKey: 'createChallengeDescription'
      _button ["button-confirm", onClick: @_postChallenge],
        "Create challenge"
