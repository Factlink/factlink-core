class window.TourController extends Backbone.Factlink.BaseController

  routes: ['interests']

  interests: ->
    users = new TourUsers
    users.fetch()
    containerRegion = new Backbone.Marionette.Region el: $("#container")
    containerRegion.show new TourInterestingUsersView
      collection: users
