class TourUserView extends Backbone.Marionette.ItemView
  template:  
    text: "BLaBla TODO: {{username}}" 

class window.TourUsersListView extends Backbone.Marionette.CollectionView
  itemView: TourUserView
