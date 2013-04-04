class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "user-social-statistics"

  initialize: ->
    @bindTo @model.followers, 'change', @render, @

  templateHelpers: =>
    plural: @plural()
    followers_count: @followers_count()

  followers_count: ->
    @model.followers.followers_count()

  plural: ->
    not (@followers_count() == 1)

# TODO:  Severe duplication with followChannelButtonView ! please refactor
class FollowUserButtonView extends Backbone.Marionette.Layout
  template: 'users/follow_user_button'
  className: 'user-follow-user-button'

  events:
    "click .js-follow-user-button": "follow"
    "click .js-unfollow-user-button": "unfollow"

    "mouseleave": "disableHoverState"
    "mouseenter": "enableHoverState"

  ui:
    defaultButton:  '.js-default-state'
    hoverButton:    '.js-hover-state'
    unfollowButton: '.js-unfollow-user-button'

  initialize: ->
    @bindTo @model.followers, 'change', @updateButton, @

  templateHelpers: =>
    follow:    Factlink.Global.t.follow.capitalize()
    unfollow:  Factlink.Global.t.unfollow.capitalize()
    following: Factlink.Global.t.following.capitalize()

  follow: (e) ->
    @justFollowed = true
    @model.follow()
    e.preventDefault()
    e.stopPropagation()

  unfollow: (e) ->
    @model.unfollow()
    e.preventDefault()
    e.stopPropagation()

  updateButton: =>
    added = @model.followers.followed_by_me()
    @$('.js-unfollow-user-button').toggle added
    @$('.js-follow-user-button').toggle not added

  enableHoverState: ->
    return if @justFollowed
    return unless @model.followers.followed_by_me()
    @ui.defaultButton.hide()
    @ui.hoverButton.show()
    @ui.unfollowButton.addClass 'btn-danger'

  disableHoverState: ->
    delete @justFollowed
    @ui.defaultButton.show()
    @ui.hoverButton.hide()
    @ui.unfollowButton.removeClass 'btn-danger'


class window.SidebarProfileView extends Backbone.Marionette.Layout
  template: 'users/profile/sidebar_profile'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'
    socialStatisticsRegion: '.js-region-user-social-statistics'
    followUserButtonRegion: '.js-region-user-follow-user'

  onRender: ->
    @model.followers.fetch()

    @profilePictureRegion.show   new UserLargeView(model: @model)
    @socialStatisticsRegion.show new SocialStatisticsView(model: @model)

    if not @model.is_current_user()
      @followUserButtonRegion.show new FollowUserButtonView(model: @model)
