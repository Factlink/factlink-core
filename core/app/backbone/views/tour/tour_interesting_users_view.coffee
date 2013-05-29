class window.TourInterestingUsersView extends Backbone.Marionette.Layout
  template: 'tour/interesting_users_layout'

  regions: 
    tourUsersRegion: '.js-region-tour-users'
  
  onRender: ->
    view = new TourUsersListView
      collection: @collection
    @tourUsersRegion.show view

