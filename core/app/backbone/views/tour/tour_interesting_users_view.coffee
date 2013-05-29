class window.TourInterestingUsersView extends Backbone.Marionette.Layout
  template: 'tour/interesting_users_layout'

  regions: 
    tourUsersRegion: '.js-region-tour-users'
  
  initialize: ->
    console.info "collection: ", @collection
    #@bindTo @collection, "add remove reset", @render, @

  onRender: ->
    console.log "rendering", @collection
    view = new TourUsersListView
      collection: @collection
    @tourUsersRegion.show view

