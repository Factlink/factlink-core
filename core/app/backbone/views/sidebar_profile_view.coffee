class SocialStatisticsView extends Backbone.Marionette.ItemView
  template:
    text: """
    followers: {{ followers_count }}
    following: {{ following_count }}
    """

class window.SidebarProfileView extends Backbone.Marionette.Layout
  template: 'users/profile/sidebar_profile'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'
    socialStatisticsRegion: '.js-region-user-social-statistics'

  onRender: ->
    @profilePictureRegion.show   new UserLargeView(model: @model)
    @socialStatisticsRegion.show new SocialStatisticsView(model: @model)
