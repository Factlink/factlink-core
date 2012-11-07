#= require ../auto_complete/search_list_view

class AutoCompleteSearchUserView extends Backbone.Factlink.StepView
  tagName: "li"

  template: "auto_complete/search_item"

  initialize: ->
    @queryRegex = new RegExp(@options.query, "gi")

  templateHelpers: ->
    view = this

    highlightedTitle: -> htmlEscape(@username).replace(view.queryRegex, "<em>$&</em>")

class window.AutoCompleteSearchUsersView extends AutoCompleteSearchListView
  itemView: AutoCompleteSearchUserView
