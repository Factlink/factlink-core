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

class window.ProfileInformationView extends Backbone.Marionette.Layout
  template: 'users/profile/profile_information'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'
    socialStatisticsRegion: '.js-region-user-social-statistics'
    followUserButtonRegion: '.js-region-user-follow-user'

  onRender: ->
    @profilePictureRegion.show   new UserView(model: @model)
    @socialStatisticsRegion.show new ReactView
      component: ReactSocialStatistics
        model: @model

    @_showFollowUserButton()

  _showFollowUserButton: ->
    return unless Factlink.Global.signed_in
    return if @model.is_current_user()

    @followUserButtonRegion.show new FollowUserButtonView(user: @model)
