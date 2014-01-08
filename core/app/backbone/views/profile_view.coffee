class window.ProfileBioView extends Backbone.Marionette.ItemView
  template: "users/profile/information"

class window.ProfileView extends Backbone.Marionette.Layout
  template:  'users/profile/index'
  className: 'profile'

  regions:
    topTopicsRegion:        '.js-top-topics-region'
    profileInformationRegion: '.profile-information'
    factRegion:               '.fact-region'

  onRender: ->
    @profileInformationRegion.show  new ProfileBioView(model: @model)
    @factRegion.show                @options.created_facts_view
    @topTopicsRegion.show new ProfileInformationView
      model: @model
