class AutoCompleteResultsUserView extends Backbone.Marionette.ItemView
  tagName: "li"

  triggers:
    "click a.icon-remove": "remove"

  template: "users/auto_complete_results_user"

class window.AutoCompleteResultsUsersView extends Backbone.Marionette.CollectionView
  itemView: AutoCompleteResultsUserView
  tagName: 'ul'
  className: 'results_channels'

  initialize: ->
    @on "itemview:remove", (childView, msg) => @collection.remove childView.model
