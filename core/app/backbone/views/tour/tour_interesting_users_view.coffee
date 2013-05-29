class window.TourInterestingUsersView extends Backbone.Marionette.Layout
  template: 'tour/interesting_users_layout'
  className: 'tour-interesting-users'

  regions:
    tourUsersRegion: '.js-region-tour-users'

  ui:
    skip: '.js-skip'
    finish: '.js-finish'

  onRender: ->
    @ui.finish.hide()
    @tourUsersRegion.show new TourUsersListView
      collection: @collection

  showFinishButton: ->
    @ui.skip.fadeOut =>
      @ui.finish.fadeIn()
