class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "user-social-statistics"

  initialize: ->
    @bindTo @model.followers, 'change', @render, @
    @bindTo @model.following, 'change', @render, @

  templateHelpers: =>
    plural_followers: @plural_followers()
    following:  @following_count_object()
    followers:  @followers_count_object()

  plural_followers: ->
    @model.followers.total_count() isnt 1

  followers_count_object: ->
    count = @model.followers.total_count()
    if count? then {count: count} else null

  following_count_object: ->
    count = @model.following.total_count()
    if count? then {count: count} else null

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
