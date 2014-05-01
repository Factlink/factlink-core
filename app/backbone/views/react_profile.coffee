ReactSocialStatistics = React.createBackboneClass
  displayName: 'ReactSocialStatistics'

  render: ->
    plural_followers = @model().get('statistics_follower_count') != 1

    _div ["profile-user-social-statistics"],
      _div ["profile-social-statistic-block"],
        _h1 [],
          @model().get('statistics_following_count')
        "following"

      _div ["profile-social-statistic-block"],
        _h1 [],
          @model().get('statistics_follower_count')
        "follower"
        "s" if plural_followers


window.ReactProfile = React.createBackboneClass
  displayName: 'ReactProfile'
  mixins: [UpdateOnSignInOrOutMixin]

  _activeUser: ->
    _div [],
      _div ['profile-box-container'],
        _div ['profile-box-item'],
          _div ['profile-information-item'],
            _div ["avatar-container--large-name"],
              @model().get('name')
            _img ["image-160px avatar-container--large-avatar",
              alt:" ",
              src: @model().avatar_url(160)]
          _div ['profile-information-item'],
            ReactSocialStatistics model: @model()
            if currentSession.signedIn() && !currentSession.isCurrentUser(@model())
              _div [],
                ReactFollowUserButton user: @model()
                ReactAddToGroupCheckboxes
                  groups: currentSession.user().groups()
                  user: @model()
        _div ['profile-box-item'],
          _h1 [],
            'Information'
          if @model().get('biography')
            _div ['profile-bio-item'],
              _span ['profile-information-label'],
                'Bio:'
              _span ['profile-information-field'],
                @model().get('biography')
          if @model().get('location')
            _div ['profile-bio-item'],
              _span ['profile-information-label'],
                'Location:'
              _span ['profile-information-field'],
                @model().get('location')
          if !@model().get('biography') && !@model().get('location')
            _div ['profile-bio-item profile-bio-item-empty'],
              "#{@model().get('name')} hasn't added their profile information yet."

      _div ['profile-feed-activities'],
        ReactFeedActivitiesAutoLoading
          model: @model().feed_activities()

  _deletedUser: ->
    _div [],
      'This profile has been deleted.'

  render: ->
    _div [],
      ReactUserTabs model: @model(), page: 'about'

      if @model().isNew()
        _img [src: Factlink.Global.ajax_loader_image]
      else if @model().get('deleted')
        @_deletedUser()
      else
        @_activeUser()
