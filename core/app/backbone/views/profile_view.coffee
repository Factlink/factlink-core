class window.ProfileBioView extends Backbone.Marionette.ItemView
  template: "users/profile/information"

class window.ProfileView extends Backbone.Marionette.Layout
  template:  'users/profile/index'

  regions:
    profileInformationRegion: '.js-profile-information-region'
    profileBioRegion: '.js-bio-region'
    factRegion: '.fact-region'
    feedRegion: '.js-feed'

  onRender: ->
    @profileInformationRegion.show new ProfileInformationView model: @model
    @profileBioRegion.show  new ProfileBioView model: @model
    @feedRegion.show new ReactView
      component: ReactFeedActivitiesAutoLoading
        model: @model.feed_activities()

