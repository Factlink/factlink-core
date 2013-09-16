class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "user-social-statistics"

  initialize: ->
    @listenTo @model.followers, 'all', @render
    @listenTo @model.following, 'all', @render

  templateHelpers: =>
    plural_followers: @model.followers.length != 1
    following: @model.following.length
    followers: @model.followers.length
    followingLoading: @model.following.loading()
    followersLoading: @model.followers.loading()

class window.SidebarProfileView extends Backbone.Marionette.Layout
  template: 'users/profile/sidebar_profile'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'
    socialStatisticsRegion: '.js-region-user-social-statistics'
    followUserButtonRegion: '.js-region-user-follow-user'

  onRender: ->
    @model.followers.fetch()
    @model.following.fetch()

    @profilePictureRegion.show   new UserLargeView(model: @model)
    @socialStatisticsRegion.show new SocialStatisticsView(model: @model)

    if not @model.is_current_user()
      @followUserButtonRegion.show new FollowUserButtonView(user: @model)
