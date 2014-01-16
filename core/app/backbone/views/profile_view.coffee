class window.ProfileBioView extends Backbone.Marionette.ItemView
  template: "users/profile/information"

class window.ProfileView extends Backbone.Marionette.Layout
  template:  'users/profile/index'
  className: 'profile'

  regions:
    profileInformationRegion: '.js-profile-information-region'
    profileBioRegion: '.js-bio-region'
    factRegion: '.fact-region'

  onRender: ->
    @factRegion.show new FactsView
      collection: new CreatedFacts([], user: @model)
      empty_view: new EmptyProfileFactsView
    @profileInformationRegion.show new ProfileInformationView model: @model
    @profileBioRegion.show  new ProfileBioView model: @model
