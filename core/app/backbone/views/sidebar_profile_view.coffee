class SocialStatisticsView extends Backbone.Marionette.ItemView
  template: "users/profile/social_statistics"
  className: "user-social-statistics"


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
    @bindTo @model.followers, 'add remove', @updateButton, @

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

  onRender: -> @updateButton()

  updateButton: =>
    added = @model.followed_by_current_user()
    @$('.js-unfollow-user-button').toggle added
    @$('.js-follow-user-button').toggle not added

  enableHoverState: ->
    return if @justFollowed
    return unless @model.followed_by_current_user()
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
    @profilePictureRegion.show   new UserLargeView(model: @model)
    @socialStatisticsRegion.show new SocialStatisticsView(model: @model)
    #@followUserButtonRegion.show new FollowUserButtonView(model: @model)
