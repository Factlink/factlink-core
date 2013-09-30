class AutoCompleteResultsUserView extends Backbone.Marionette.ItemView
  tagName: "li"
  className: 'auto-complete-result-item'

  triggers:
    "click a.icon-remove": "remove"

  template: "users/auto_complete_results_user"

class window.AutoCompleteResultsUsersView extends Backbone.Marionette.CollectionView
  itemView: AutoCompleteResultsUserView
  tagName: 'ul'
  className: 'auto-complete-results'

  initialize: ->
    @on "itemview:remove", (childView, msg) => @collection.remove childView.model
