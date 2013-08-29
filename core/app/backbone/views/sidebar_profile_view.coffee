count_object_or_null = (count) ->
  if count? then {count: count} else null

class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "user-social-statistics"

  initialize: ->
    @listenTo @model.followers, 'all', @render
    @listenTo @model.following, 'all', @render

  templateHelpers: =>
    plural_followers: @plural_followers()
    following: count_object_or_null(@following_count())
    followers: count_object_or_null(@followers_count())

  plural_followers: -> @followers_count() isnt 1
  followers_count: -> @model.followers.length
  following_count: -> @model.following.length

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
