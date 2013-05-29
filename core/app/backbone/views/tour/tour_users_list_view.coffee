class TourUserView extends Backbone.Marionette.ItemView
  template: 'tour/interesting_user'
  className: 'tour-interesting-user'
  onRender: ->
    console.log @

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
