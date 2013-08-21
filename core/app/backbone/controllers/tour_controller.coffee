class window.TourController extends Backbone.Marionette.Controller

  interests: ->
    users = new TourUsers
    users.fetch()
    containerRegion = new Backbone.Marionette.Region el: $("#container")
    containerRegion.show new TourInterestingUsersView
      collection: users
