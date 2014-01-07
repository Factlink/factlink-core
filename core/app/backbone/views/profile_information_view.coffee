class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "profile-user-social-statistics"

  initialize: ->
    @listenTo @model, 'change', @render

  templateHelpers: =>
    plural_followers: @model.get('statistics_follower_count') != 1

class window.ProfileInformationView extends Backbone.Marionette.Layout
  template: 'users/profile/profile_information'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'
    socialStatisticsRegion: '.js-region-user-social-statistics'
    followUserButtonRegion: '.js-region-user-follow-user'

  onRender: ->
    @profilePictureRegion.show   new UserLargeView(model: @model)
    @socialStatisticsRegion.show new SocialStatisticsView(model: @model)

    @_showFollowUserButton()

  _showFollowUserButton: ->
    return unless Factlink.Global.signed_in
    return if @model.is_current_user()

    @followUserButtonRegion.show new FollowUserButtonView(user: @model)
