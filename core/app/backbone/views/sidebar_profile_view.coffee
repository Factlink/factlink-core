class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "user-social-statistics"

  initialize: ->
    @bindTo @model.followers, 'change', @render, @
    @bindTo @model.following, 'change', @render, @

  templateHelpers: =>
    plural_followers: @plural_followers()
    followers_count:  @followers_count()
    following_count:  @following_count()

  followers_count: ->
    @model.followers.followers_count()

  plural_followers: ->
    not (@followers_count() == 1)

  following_count: ->
    @model.following.following_count()

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
      @followUserButtonRegion.show new FollowUserButtonView(model: @model)
