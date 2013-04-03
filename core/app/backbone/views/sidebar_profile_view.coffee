class window.SidebarProfileView extends Backbone.Marionette.Layout
  template: 'users/profile/sidebar_profile'

  regions:
    profilePictureRegion:   '.js-region-user-large-profile-picture'

  onRender: ->
    @profilePictureRegion.show   new UserLargeView(model: @model)
