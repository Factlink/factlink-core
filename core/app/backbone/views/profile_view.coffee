class window.ProfileInformationView extends Backbone.Marionette.ItemView
  template: "users/profile/information"

class window.ProfileView extends Backbone.Marionette.Layout
  template:  'users/profile/index'
  className: 'profile'

  regions:
    topTopicsRegion:        '.js-top-topics-region'
    profileInformationRegion: '.profile-information'
    factRegion:               '.fact-region'

  onRender: ->
    @profileInformationRegion.show  new ProfileInformationView(model: @model)
    @factRegion.show                @options.created_facts_view
    @_showTopTopicsView()

  _showTopTopicsView: ->
    @topTopicsRegion.show new TopTopicsView
      collection: @collection
      user: @model
